import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/local_models/calendar_day.dart';
import 'package:radency_internship_project_2/local_models/transactions/expense_transaction.dart';
import 'package:radency_internship_project_2/local_models/transactions/income_transaction.dart';
import 'package:radency_internship_project_2/local_models/transactions/transaction.dart';
import 'package:radency_internship_project_2/local_models/transactions/transactions_helper.dart';
import 'package:radency_internship_project_2/local_models/transactions/transfer_transaction.dart';
import 'package:radency_internship_project_2/local_models/user.dart';
import 'package:radency_internship_project_2/providers/firebase_auth_service.dart';
import 'package:radency_internship_project_2/repositories/transactions_repository.dart';
import 'package:radency_internship_project_2/utils/date_helper.dart';

part 'transactions_calendar_event.dart';

part 'transactions_calendar_state.dart';

class TransactionsCalendarBloc extends Bloc<TransactionsCalendarEvent, TransactionsCalendarState> {
  TransactionsCalendarBloc({
    required this.settingsBloc,
    required this.transactionsRepository,
    // required this.firebaseAuthenticationService,
    // required this.firebaseRealtimeDatabaseProvider,
  }) : super(TransactionsCalendarInitial());

  // final FirebaseAuthenticationService firebaseAuthenticationService;
  final TransactionsRepository transactionsRepository;
  // final FirebaseRealtimeDatabaseProvider firebaseRealtimeDatabaseProvider;

  SettingsBloc settingsBloc;
  StreamSubscription? settingsSubscription;
  String locale = '';

  DateTime? _observedDate;
  String _sliderCurrentTimeIntervalString = '';

  List<AppTransaction> transactionsList = [];
  List<CalendarDay> calendarData = [];
  double expensesSummary = 0;
  double incomeSummary = 0;

  /// In accordance with ISO 8601
  /// a week starts with Monday, which has the value 1.
  final int startOfWeek = 1;
  final int endOfWeek = 7;

  StreamSubscription? calendarTransactionsSubscription;

  // StreamSubscription<DatabaseEvent>? _onTransactionAddedSubscription;
  // StreamSubscription<DatabaseEvent>? _onTransactionChangedSubscription;
  // StreamSubscription<DatabaseEvent>? _onTransactionDeletedSubscription;
  StreamSubscription<UserEntity>? _onUserChangedSubscription;

  @override
  Stream<TransactionsCalendarState> mapEventToState(
    TransactionsCalendarEvent event,
  ) async* {
    if (event is TransactionsCalendarInitialize) {
      yield* _mapTransactionsCalendarInitializeToState();
    } else if (event is TransactionsCalendarGetPreviousMonthPressed) {
      yield* _mapTransactionsCalendarGetPreviousMonthPressedToState();
    } else if (event is TransactionsCalendarGetNextMonthPressed) {
      yield* _mapTransactionsCalendarGetNextMonthPressedToState();
    } else if (event is TransactionsCalendarFetchRequested) {
      yield* _mapTransactionsCalendarFetchRequestedToState(dateForFetch: event.dateForFetch);
    } else if (event is TransactionsCalendarDisplayRequested) {
      yield* _mapTransactionCalendarDisplayRequestedToState(
        data: event.daysData,
        expenses: event.expensesSummary,
        income: event.incomeSummary,
      );
    } else if (event is TransactionsCalendarLocaleChanged) {
      yield* _mapTransactionsCalendarLocaleChangedToState();
    } else if (event is TransactionsCalendarUserChanged) {
      yield* _mapTransactionsCalendarUserChangedToState(event.id);
    }
  }

  @override
  Future<void> close() {
    calendarTransactionsSubscription?.cancel();
    settingsSubscription?.cancel();
    // _onTransactionChangedSubscription?.cancel();
    // _onTransactionAddedSubscription?.cancel();
    // _onTransactionDeletedSubscription?.cancel();
    _onUserChangedSubscription?.cancel();
    return super.close();
  }

  Stream<TransactionsCalendarState> _mapTransactionsCalendarInitializeToState() async* {
    _observedDate = DateTime.now();
    add(TransactionsCalendarFetchRequested(dateForFetch: _observedDate!));

    // _onUserChangedSubscription = firebaseAuthenticationService.userFromAuthState.listen((user) {
    //   // _onTransactionChangedSubscription?.cancel();
    //   // _onTransactionAddedSubscription?.cancel();
    //   // _onTransactionDeletedSubscription?.cancel();
    //
    //   if (user == UserEntity.empty) {
    //     calendarData.clear();
    //     transactionsList.clear();
    //     add(TransactionsCalendarDisplayRequested(
    //       sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString,
    //       daysData: calendarData,
    //       incomeSummary: 0.0,
    //       expensesSummary: 0.0,
    //     ));
    //   } else {
    //     add(TransactionsCalendarUserChanged(id: user.id));
    //   }
    // });

    if (settingsBloc.state is LoadedSettingsState) {
      locale = settingsBloc.state.language;
    }
    settingsBloc.stream.listen((newSettingsState) {
      print("TransactionsCalendarBloc._mapTransactionsCalendarInitializeToState: newSettingsState");
      if (newSettingsState is LoadedSettingsState && newSettingsState.language != locale) {
        locale = newSettingsState.language;
        add(TransactionsCalendarLocaleChanged());
      }
    });
  }

  Stream<TransactionsCalendarState> _mapTransactionsCalendarLocaleChangedToState() async* {
    _sliderCurrentTimeIntervalString = DateHelper().monthNameAndYearFromDateTimeString(_observedDate!, locale: locale);

    print("TransactionsCalendarBloc._mapTransactionsCalendarLocaleChangedToState: $_sliderCurrentTimeIntervalString");

    if (state is TransactionsCalendarLoaded) {
      add(TransactionsCalendarDisplayRequested(
        daysData: calendarData,
        sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString,
        expensesSummary: expensesSummary,
        incomeSummary: incomeSummary,
      ));
    } else if (state is TransactionsCalendarLoading) {
      yield TransactionsCalendarLoading(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);
    }
  }

  Stream<TransactionsCalendarState> _mapTransactionsCalendarFetchRequestedToState(
      {required DateTime dateForFetch}) async* {
    calendarTransactionsSubscription?.cancel();

    _sliderCurrentTimeIntervalString = DateHelper().monthNameAndYearFromDateTimeString(_observedDate!);
    yield TransactionsCalendarLoading(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);

    calendarTransactionsSubscription = transactionsRepository
        .getTransactionsByTimePeriod(
            start: DateHelper().getFirstDayOfMonth(_observedDate!), end: DateHelper().getLastDayOfMonth(_observedDate!))
        .asStream()
        .listen((event) {
      transactionsList = event;
      calendarData = _convertTransactionsToCalendarData(transactionsList, _observedDate!);
      add(TransactionsCalendarDisplayRequested(
        daysData: calendarData,
        sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString,
        expensesSummary: expensesSummary,
        incomeSummary: incomeSummary,
      ));
    });
  }

  Stream<TransactionsCalendarState> _mapTransactionsCalendarUserChangedToState(String id) async* {
    yield TransactionsCalendarLoading(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);

    // FirebaseStreamsGroup streams = await firebaseRealtimeDatabaseProvider.transactionStreams(id);
    // _onTransactionAddedSubscription = streams.onChildAdded.listen(_onTransactionAdded);
    // _onTransactionChangedSubscription = streams.onChildChanged.listen(_onTransactionChanged);
    // _onTransactionDeletedSubscription = streams.onChildDeleted.listen(_onTransactionDeleted);

    _observedDate = DateTime.now();

    add(TransactionsCalendarFetchRequested(dateForFetch: _observedDate!));
  }

  Stream<TransactionsCalendarState> _mapTransactionCalendarDisplayRequestedToState(
      {required List<CalendarDay> data, required double income, required double expenses}) async* {
    yield TransactionsCalendarLoaded(
        daysData: data,
        sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString,
        incomeSummary: income,
        expensesSummary: expenses);
  }

  Stream<TransactionsCalendarState> _mapTransactionsCalendarGetPreviousMonthPressedToState() async* {
    _observedDate = DateTime(_observedDate!.year, _observedDate!.month - 1);
    add(TransactionsCalendarFetchRequested(dateForFetch: _observedDate!));
  }

  Stream<TransactionsCalendarState> _mapTransactionsCalendarGetNextMonthPressedToState() async* {
    _observedDate = DateTime(_observedDate!.year, _observedDate!.month + 1);
    add(TransactionsCalendarFetchRequested(dateForFetch: _observedDate!));
  }

  // _onTransactionAdded(DatabaseEvent event) async {
  //   print('TransactionsBloc: snapshot ${event.snapshot}');
  //   AppTransaction transaction = TransactionsHelper()
  //       .convertJsonToTransaction(json: Map<String, dynamic>.from(event.snapshot.value as Map), key: event.snapshot.key!);
  //
  //   // TODO: refactor
  //   if ((transaction.date.isAfter(DateHelper().getFirstDayOfMonth(_observedDate!)) ||
  //           transaction.date == DateHelper().getFirstDayOfMonth(_observedDate!)) &&
  //       transaction.date.isBefore(DateHelper().getLastDayOfMonth(_observedDate!))) {
  //     transactionsList.add(transaction);
  //     calendarData = _convertTransactionsToCalendarData(transactionsList, _observedDate!);
  //     add(TransactionsCalendarDisplayRequested(
  //       daysData: calendarData,
  //       sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString,
  //       expensesSummary: expensesSummary,
  //       incomeSummary: incomeSummary,
  //     ));
  //   }
  // }
  //
  // _onTransactionChanged(DatabaseEvent event) async {
  //   int oldTransactionIndex = transactionsList.indexWhere((transaction) => transaction.id == event.snapshot.key);
  //   AppTransaction changedTransaction = TransactionsHelper()
  //       .convertJsonToTransaction(json: Map<String, dynamic>.from(event.snapshot.value as Map), key: event.snapshot.key!);
  //   if (oldTransactionIndex != -1) {
  //     transactionsList[oldTransactionIndex] = changedTransaction;
  //   }
  //   calendarData = _convertTransactionsToCalendarData(transactionsList, _observedDate!);
  //   add(TransactionsCalendarDisplayRequested(
  //     daysData: calendarData,
  //     sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString,
  //     expensesSummary: expensesSummary,
  //     incomeSummary: incomeSummary,
  //   ));
  // }
  //
  // _onTransactionDeleted(DatabaseEvent event) async {
  //   int index = transactionsList.indexWhere((transaction) => transaction.id == event.snapshot.key);
  //   if (index != -1) {
  //     transactionsList.removeAt(index);
  //   }
  //
  //   calendarData = _convertTransactionsToCalendarData(transactionsList, _observedDate!);
  //   add(TransactionsCalendarDisplayRequested(
  //     daysData: calendarData,
  //     sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString,
  //     expensesSummary: expensesSummary,
  //     incomeSummary: incomeSummary,
  //   ));
  // }

  List<CalendarDay> _convertTransactionsToCalendarData(List<AppTransaction> transactions, DateTime observedDateTime) {
    List<CalendarDay> days = [];
    incomeSummary = 0;
    expensesSummary = 0;

    int currentMonth = observedDateTime.month;

    DateTime observedDay = DateTime(observedDateTime.year, observedDateTime.month, 1);
    while (observedDay.weekday != startOfWeek) {
      observedDay = DateTime(observedDay.year, observedDay.month, observedDay.day - 1);
    }

    while (days.length != 42) {
      List<AppTransaction> dayTransactions = [];
      String displayedDate = observedDay.day == 1 ? '${observedDay.day}.${observedDay.month}' : '${observedDay.day}';
      double expensesAmount = 0;
      double incomeAmount = 0;
      double transferAmount = 0;

      if (observedDay.month == currentMonth) {
        transactions.forEach((element) {
          if (element.date.month == observedDay.month && element.date.day == observedDay.day) {
            dayTransactions.add(element);

            if (element is ExpenseTransaction) {
              expensesAmount = expensesAmount + element.amount;
              expensesSummary = expensesSummary + element.amount;
            } else if (element is IncomeTransaction) {
              incomeAmount = incomeAmount + element.amount;
              incomeSummary = incomeSummary + element.amount;
            } else if (element is TransferTransaction) {
              transferAmount = transferAmount + element.amount;
            }
          }
        });
      }

      days.add(CalendarDay(
          dateTime: observedDay,
          displayedDate: displayedDate,
          isActive: observedDay.month == currentMonth,
          transactions: dayTransactions,
          expensesAmount: expensesAmount,
          incomeAmount: incomeAmount,
          transferAmount: transferAmount));

      observedDay = DateTime(observedDay.year, observedDay.month, observedDay.day + 1);
    }

    return days;
  }
}
