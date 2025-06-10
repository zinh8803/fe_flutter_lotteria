import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/invoice/statistic_bloc.dart';
import 'package:frontend_appflowershop/bloc/invoice/statistic_state.dart';
import 'package:frontend_appflowershop/bloc/invoice/statistic_event.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import 'package:frontend_appflowershop/data/models/invoice.dart';

class AdminStatisticScreen extends StatefulWidget {
  const AdminStatisticScreen({super.key});

  @override
  State<AdminStatisticScreen> createState() => _AdminStatisticScreenState();
}

class _AdminStatisticScreenState extends State<AdminStatisticScreen> {
  String _selectedTimeRange = 'Tuần này';
  final List<String> _timeRanges = [
    'Tuần này',
    'Tháng này',
    'Quý này',
    'Năm nay',
    'Tất cả'
  ];

  @override
  void initState() {
    super.initState();
    context.read<StatisticBloc>().add(FetchInvoicesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống Kê Doanh Thu'),
      ),
      body: BlocBuilder<StatisticBloc, StatisticState>(
        builder: (context, state) {
          if (state is StatisticLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StatisticError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          } else if (state is StatisticLoaded) {
            return _buildStatisticContent(state.invoices);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildStatisticContent(List<InvoiceModel> invoices) {
    // Xử lý dữ liệu cho biểu đồ
    final dailyData = _processDailyData(invoices);
    final monthlyData = _processMonthlyData(invoices);
    final paymentMethodData = _processPaymentMethodData(invoices);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown chọn khoảng thời gian
          DropdownButton<String>(
            value: _selectedTimeRange,
            items: _timeRanges.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedTimeRange = newValue!;
              });
            },
          ),
          const SizedBox(height: 20),

          // Tổng doanh thu
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tổng Doanh Thu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_calculateTotalRevenue(invoices).toStringAsFixed(0)}đ',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Biểu đồ doanh thu theo ngày
          const Text(
            'Doanh Thu Theo Ngày',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <CartesianSeries>[
                ColumnSeries<DailyRevenue, String>(
                  dataSource: dailyData,
                  xValueMapper: (DailyRevenue data, _) => data.date,
                  yValueMapper: (DailyRevenue data, _) => data.revenue,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                  color: Colors.blue,
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Biểu đồ doanh thu theo tháng
          const Text(
            'Doanh Thu Theo Tháng',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <CartesianSeries>[
                ColumnSeries<MonthlyRevenue, String>(
                  dataSource: monthlyData,
                  xValueMapper: (MonthlyRevenue data, _) => data.month,
                  yValueMapper: (MonthlyRevenue data, _) => data.revenue,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                  color: Colors.green,
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Biểu đồ phương thức thanh toán
          const Text(
            'Phương Thức Thanh Toán',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: SfCircularChart(
              series: <CircularSeries>[
                PieSeries<PaymentMethodData, String>(
                  dataSource: paymentMethodData,
                  xValueMapper: (PaymentMethodData data, _) => data.method,
                  yValueMapper: (PaymentMethodData data, _) => data.amount,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    textStyle: TextStyle(fontSize: 12),
                  ),
                  pointColorMapper: (PaymentMethodData data, _) {
                    if (data.method == 'Tiền mặt') {
                      return Colors.green; 
                    } else {
                      return Colors.blue; 
                    }
                  },
                  // Thêm chú thích
                  legendIconType: LegendIconType.circle,
                  enableTooltip: true,
                )
              ],
              // Thêm chú thích
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                overflowMode: LegendItemOverflowMode.wrap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotalRevenue(List<InvoiceModel> invoices) {
    return invoices.fold(0, (sum, invoice) => sum + invoice.totalAmount);
  }

  List<DailyRevenue> _processDailyData(List<InvoiceModel> invoices) {
    final Map<String, double> dailyMap = {};

    for (var invoice in invoices) {
      final date = DateFormat('dd/MM').format(invoice.invoiceDate);
      dailyMap[date] = (dailyMap[date] ?? 0) + invoice.totalAmount;
    }

    return dailyMap.entries
        .map((e) => DailyRevenue(e.key, e.value))
        .toList()
        .reversed
        .toList();
  }

  List<MonthlyRevenue> _processMonthlyData(List<InvoiceModel> invoices) {
    final Map<String, double> monthlyMap = {};

    for (var invoice in invoices) {
      final month = DateFormat('MM/yyyy').format(invoice.invoiceDate);
      monthlyMap[month] = (monthlyMap[month] ?? 0) + invoice.totalAmount;
    }

    return monthlyMap.entries
        .map((e) => MonthlyRevenue(e.key, e.value))
        .toList()
        .reversed
        .toList();
  }

  List<PaymentMethodData> _processPaymentMethodData(
      List<InvoiceModel> invoices) {
    final Map<String, double> methodMap = {};

    for (var invoice in invoices) {
      final method = invoice.paymentMethod == 'cash' ? 'Tiền mặt' : 'VNPay';
      methodMap[method] = (methodMap[method] ?? 0) + invoice.totalAmount;
    }

    return methodMap.entries
        .map((e) => PaymentMethodData(e.key, e.value))
        .toList();
  }
}

class DailyRevenue {
  final String date;
  final double revenue;

  DailyRevenue(this.date, this.revenue);
}

class MonthlyRevenue {
  final String month;
  final double revenue;

  MonthlyRevenue(this.month, this.revenue);
}

class PaymentMethodData {
  final String method;
  final double amount;

  PaymentMethodData(this.method, this.amount);
}
