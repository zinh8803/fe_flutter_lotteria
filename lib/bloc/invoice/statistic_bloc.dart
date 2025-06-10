import 'package:bloc/bloc.dart';
import 'package:frontend_appflowershop/bloc/invoice/statistic_event.dart';
import 'package:frontend_appflowershop/bloc/invoice/statistic_state.dart';
import 'package:frontend_appflowershop/data/services/invoice/api_statistic.dart';


class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  final ApiStatisticService apiService;

  StatisticBloc(this.apiService) : super(StatisticInitial()) {
    on<FetchInvoicesEvent>((event, emit) async {
      emit(StatisticLoading());
      try {
        final invoices = await apiService.getInvoices();
        emit(StatisticLoaded(invoices));
      } catch (e) {
        emit(StatisticError(e.toString()));
      }
    });
  }
}
