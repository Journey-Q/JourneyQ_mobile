import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/data.dart';

class BudgetTrackerScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final List<Map<String, dynamic>> members;

  const BudgetTrackerScreen({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.members,
  });

  @override
  State<BudgetTrackerScreen> createState() => _BudgetTrackerScreenState();
}

class _BudgetTrackerScreenState extends State<BudgetTrackerScreen> {
  Map<String, Map<String, double>> memberExpenses = {};
  Map<String, bool> expandedMembers = {};

  @override
  void initState() {
    super.initState();
    _initializeBudgetData();
  }

  void _initializeBudgetData() {
    final groupBudgetData = SampleData.getGroupBudgetData(widget.groupId);
    
    for (var member in widget.members) {
      String memberId = member['id'];
      
      if (groupBudgetData != null && groupBudgetData[memberId] != null) {
        memberExpenses[memberId] = Map<String, double>.from(groupBudgetData[memberId]!);
      } else {
        memberExpenses[memberId] = {
          'travel': 0.0,
          'food': 0.0,
          'hotel': 0.0,
          'other': 0.0,
        };
      }
      expandedMembers[memberId] = false;
    }
  }

  double _getTotalExpenseForMember(String memberId) {
    final expenses = memberExpenses[memberId]!;
    return expenses.values.fold(0.0, (sum, expense) => sum + expense);
  }

  double _getTotalGroupExpense() {
    return memberExpenses.values.fold(0.0, (sum, expenses) {
      return sum + expenses.values.fold(0.0, (subSum, expense) => subSum + expense);
    });
  }

  double _getAverageExpensePerMember() {
    if (widget.members.isEmpty) return 0.0;
    return _getTotalGroupExpense() / widget.members.length;
  }

  Map<String, double> _calculateSettlements() {
    final averageExpense = _getAverageExpensePerMember();
    Map<String, double> settlements = {};
    
    for (var member in widget.members) {
      final totalExpense = _getTotalExpenseForMember(member['id']);
      settlements[member['id']] = averageExpense - totalExpense;
    }
    
    return settlements;
  }

  String _getDetailedSettlementText(String memberId, double settlement) {
    if (settlement.abs() < 0.01) {
      return 'All settled! No money exchange needed.';
    } else if (settlement > 0) {
      final settlements = _calculateSettlements();
      final debtors = settlements.entries
          .where((entry) => entry.value < 0)
          .toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      
      if (debtors.isNotEmpty) {
        final debtorName = widget.members
            .firstWhere((m) => m['id'] == debtors.first.key)['name'];
        return 'Should receive LKR ${settlement.toStringAsFixed(0)} from $debtorName';
      }
      return 'Should receive LKR ${settlement.toStringAsFixed(0)}';
    } else {
      final settlements = _calculateSettlements();
      final creditors = settlements.entries
          .where((entry) => entry.value > 0)
          .toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      
      if (creditors.isNotEmpty) {
        final creditorName = widget.members
            .firstWhere((m) => m['id'] == creditors.first.key)['name'];
        return 'Owes LKR ${settlement.abs().toStringAsFixed(0)} to $creditorName';
      }
      return 'Owes LKR ${settlement.abs().toStringAsFixed(0)}';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'travel':
        return const Color(0xFFE3F2FD); // Light blue
      case 'food':
        return const Color(0xFFE8F5E8); // Light green
      case 'hotel':
        return const Color(0xFFFFF3E0); // Light orange
      case 'other':
        return const Color(0xFFFCE4EC); // Light pink
      default:
        return Colors.grey[100]!;
    }
  }

  Color _getCategoryIconColor(String category) {
    switch (category) {
      case 'travel':
        return const Color(0xFF1976D2); // Blue
      case 'food':
        return const Color(0xFF388E3C); // Green
      case 'hotel':
        return const Color(0xFFF57C00); // Orange
      case 'other':
        return const Color(0xFFC2185B); // Pink
      default:
        return Colors.grey[600]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settlements = _calculateSettlements();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.groupName} Budget',
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Track expenses and settlements',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Expenses',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'LKR ${_getTotalGroupExpense().toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.grey[300],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Per Person',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'LKR ${_getAverageExpensePerMember().toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Members List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.members.length,
              itemBuilder: (context, index) {
                final member = widget.members[index];
                final memberId = member['id'];
                final isExpanded = expandedMembers[memberId] ?? false;
                final settlement = settlements[memberId] ?? 0.0;
                final totalSpent = _getTotalExpenseForMember(memberId);
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          setState(() {
                            expandedMembers[memberId] = !isExpanded;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[100],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    member['avatar'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: Icon(
                                          Icons.person,
                                          size: 28,
                                          color: Colors.grey[600],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              
                              Expanded(
                                child: Text(
                                  member['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'LKR ${totalSpent.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              
                              Icon(
                                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: Colors.grey[600],
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      if (isExpanded) ...[
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey[100],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Expense Breakdown',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              _buildExpenseRow(memberId, 'Travel', 'travel', Icons.flight),
                              _buildExpenseRow(memberId, 'Food', 'food', Icons.restaurant),
                              _buildExpenseRow(memberId, 'Hotel', 'hotel', Icons.hotel),
                              _buildExpenseRow(memberId, 'Other', 'other', Icons.more_horiz),
                              
                              const SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                height: 1,
                                color: Colors.grey[100],
                              ),
                              const SizedBox(height: 16),
                              
                              const Text(
                                'Settlement Status',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: settlement > 0.01 ? const Color(0xFFE8F5E8) :
                                          settlement < -0.01 ? const Color(0xFFFFEBEE) : const Color(0xFFE3F2FD),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: settlement > 0.01 ? const Color(0xFF4CAF50) :
                                                settlement < -0.01 ? const Color(0xFFE57373) : const Color(0xFF2196F3),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        settlement > 0.01 ? Icons.trending_up :
                                         settlement < -0.01 ? Icons.trending_down : Icons.check_circle,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _getDetailedSettlementText(memberId, settlement),
                                        style: TextStyle(
                                          color: settlement > 0.01 ? const Color(0xFF2E7D32) :
                                                  settlement < -0.01 ? const Color(0xFFC62828) : const Color(0xFF1565C0),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getExpenseBreakdownText(String memberId) {
    final expenses = memberExpenses[memberId]!;
    List<String> nonZeroExpenses = [];
    
    if (expenses['travel']! > 0) nonZeroExpenses.add('Travel');
    if (expenses['food']! > 0) nonZeroExpenses.add('Food');
    if (expenses['hotel']! > 0) nonZeroExpenses.add('Hotel');
    if (expenses['other']! > 0) nonZeroExpenses.add('Other');
    
    if (nonZeroExpenses.isEmpty) {
      return 'No expenses recorded';
    } else if (nonZeroExpenses.length <= 2) {
      return nonZeroExpenses.join(', ');
    } else {
      return '${nonZeroExpenses.take(2).join(', ')} +${nonZeroExpenses.length - 2} more';
    }
  }

  Widget _buildExpenseRow(String memberId, String category, String key, IconData icon) {
    final expense = memberExpenses[memberId]![key]!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _getCategoryIconColor(key), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              category,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _editExpense(memberId, key, category, expense),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getCategoryColor(key),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'LKR ${expense.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getCategoryIconColor(key),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.edit, size: 16, color: _getCategoryIconColor(key)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editExpense(String memberId, String category, String categoryName, double currentAmount) {
    final controller = TextEditingController(text: currentAmount.toStringAsFixed(0));
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Edit $categoryName Expense',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Member: ${widget.members.firstWhere((m) => m['id'] == memberId)['name']}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '$categoryName Amount',
                prefixText: 'LKR ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF0088cc), width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final newAmount = double.tryParse(controller.text);
              if (newAmount != null && newAmount >= 0) {
                setState(() {
                  memberExpenses[memberId]![category] = newAmount;
                });
                SampleData.updateMemberExpense(widget.groupId, memberId, category, newAmount);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$categoryName expense updated!'),
                    backgroundColor: const Color(0xFF4CAF50),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0088cc),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}