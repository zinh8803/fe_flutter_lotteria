import 'package:frontend_appflowershop/data/models/invoice.dart';

abstract class StatisticState {}

class StatisticInitial extends StatisticState {}

class StatisticLoading extends StatisticState {}

class StatisticLoaded extends StatisticState {
  final List<InvoiceModel> invoices;

  StatisticLoaded(this.invoices);
}

class StatisticError extends StatisticState {
  final String message;

  StatisticError(this.message);
}