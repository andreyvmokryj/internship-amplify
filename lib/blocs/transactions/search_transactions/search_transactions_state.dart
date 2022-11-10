part of 'search_transactions_bloc.dart';

abstract class SearchTransactionsState extends Equatable{
  @override
  List<Object> get props => [];
}

class SearchTransactionsInitial extends SearchTransactionsState{}

class SearchTransactionsLoading extends SearchTransactionsState{}

class SearchTransactionsLoaded extends SearchTransactionsState{
  final List<Transaction> transactions;

  SearchTransactionsLoaded({this.transactions});

  @override
  List<Object> get props => [...transactions];
}