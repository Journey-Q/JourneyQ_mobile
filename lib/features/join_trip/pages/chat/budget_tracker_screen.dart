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
    // Get real expense data from SampleData or initialize with zeros
    final groupBudgetData = SampleData.getGroupBudgetData(widget.groupId);
    
    for (var member in widget.members) {
      String memberId = member['id'];
      
      if (groupBudgetData != null && groupBudgetData[memberId] != null) {
        // Use real data from SampleData
        memberExpenses[memberId] = Map<String, double>.from(groupBudgetData[memberId]!);
      } else {
        // Initialize with zeros if no data available
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

  String _getSettlementText(String memberId, double settlement) {
    if (settlement.abs() < 0.01) {
      return 'All settled!';
    } else if (settlement > 0) {
      return 'Should receive LKR ${settlement.toStringAsFixed(0)}';
    } else {
      return 'Owes LKR ${settlement.abs().toStringAsFixed(0)}';
    }
  }

  String _getDetailedSettlementText(String memberId, double settlement) {
    if (settlement.abs() < 0.01) {
      return 'All settled! No money exchange needed.';
    } else if (settlement > 0) {
      // Find who owes this person money
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
      // Find who this person should pay
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

  @override
  Widget build(BuildContext context) {
    final settlements = _calculateSettlements();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.groupName} Budget',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Total: LKR ${_getTotalGroupExpense().toStringAsFixed(0)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Expenses',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'LKR ${_getTotalGroupExpense().toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Per Person',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'LKR ${_getAverageExpensePerMember().toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
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
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Member Header
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          setState(() {
                            expandedMembers[memberId] = !isExpanded;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(member['avatar']),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      member['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Spent: LKR ${_getTotalExpenseForMember(memberId).toStringAsFixed(0)}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      _getSettlementText(memberId, settlement),
                                      style: TextStyle(
                                        color: settlement > 0 ? Colors.green[600] : 
                                               settlement < 0 ? Colors.red[600] : Colors.blue[600],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: settlement > 0 ? Colors.green[50] : 
                                         settlement < 0 ? Colors.red[50] : Colors.blue[50],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: settlement > 0 ? Colors.green[200]! : 
                                           settlement < 0 ? Colors.red[200]! : Colors.blue[200]!,
                                  ),
                                ),
                                child: Text(
                                  settlement > 0 
                                      ? '+${settlement.abs().toStringAsFixed(0)}'
                                      : settlement < 0 
                                          ? '-${settlement.abs().toStringAsFixed(0)}'
                                          : '0',
                                  style: TextStyle(
                                    color: settlement > 0 ? Colors.green[700] : 
                                           settlement < 0 ? Colors.red[700] : Colors.blue[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Expanded Details
                      if (isExpanded) ...[
                        const Divider(height: 1),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Expense Breakdown',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              // Expense Categories
                              _buildExpenseRow(memberId, 'Travel', 'travel', Icons.flight, Colors.blue),
                              _buildExpenseRow(memberId, 'Food', 'food', Icons.restaurant, Colors.orange),
                              _buildExpenseRow(memberId, 'Hotel', 'hotel', Icons.hotel, Colors.purple),
                              _buildExpenseRow(memberId, 'Other', 'other', Icons.more_horiz, Colors.grey),
                              
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 12),
                              
                              // Settlement Details
                              const Text(
                                'Settlement Status',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: settlement > 0 ? Colors.green[50] : 
                                         settlement < 0 ? Colors.red[50] : Colors.blue[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: settlement > 0 ? Colors.green[200]! : 
                                           settlement < 0 ? Colors.red[200]! : Colors.blue[200]!,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      settlement > 0 ? Icons.trending_up : 
                                      settlement < 0 ? Icons.trending_down : Icons.check_circle,
                                      color: settlement > 0 ? Colors.green[700] : 
                                             settlement < 0 ? Colors.red[700] : Colors.blue[700],
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _getDetailedSettlementText(memberId, settlement),
                                        style: TextStyle(
                                          color: settlement > 0 ? Colors.green[700] : 
                                                 settlement < 0 ? Colors.red[700] : Colors.blue[700],
                                          fontWeight: FontWeight.w600,
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

  Widget _buildExpenseRow(String memberId, String category, String key, IconData icon, Color color) {
    final expense = memberExpenses[memberId]![key]!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color.withOpacity(0.8),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _editExpense(memberId, key, category, expense),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'LKR ${expense.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.edit, size: 14, color: color),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit $categoryName Expense'),
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
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newAmount = double.tryParse(controller.text);
              if (newAmount != null && newAmount >= 0) {
                setState(() {
                  memberExpenses[memberId]![category] = newAmount;
                });
                // Update in SampleData as well
                SampleData.updateMemberExpense(widget.groupId, memberId, category, newAmount);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$categoryName expense updated!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0088cc),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}