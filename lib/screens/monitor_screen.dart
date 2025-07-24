import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  final binsController = TextEditingController();
  List<Map<String, dynamic>> binRecords = [];
  bool isLoading = true;
  bool isSubmitting = false;

  final String insertApiUrl = "http://192.168.1.11/robot_cleaner/insert_bins.php";
  final String fetchApiUrl = "http://192.168.1.11/robot_cleaner/fetch_bins.php";

  @override
  void initState() {
    super.initState();
    fetchBinRecords();
  }

  Future<void> fetchBinRecords() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse(fetchApiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          binRecords = data.map((record) => {
            "bins": record['bins_filled']?.toString() ?? '0', // Handle potential null
            "date": record['date_collected']?.toString() ?? 'Unknown' // Handle potential null
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      _showError("Failed to fetch records: ${e.toString()}");
      setState(() => isLoading = false);
    }
  }

  Future<void> addBinRecord() async {
    // Validate input
    if (binsController.text.isEmpty) {
      _showError("Please enter number of bins filled");
      return;
    }

    // Parse and validate the number
    final bins = int.tryParse(binsController.text);
    if (bins == null || bins < 0) {
      _showError("Please enter a valid positive number");
      return;
    }

    // Format date
    final date = DateFormat('MM/dd/yy').format(DateTime.now());
    
    setState(() => isSubmitting = true);

    try {
      final response = await http.post(
        Uri.parse(insertApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "bins_filled": bins,
          "date_collected": date,
        }),
      );

      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        // Refresh data after successful insert
        await fetchBinRecords();
        binsController.clear();
        _showSuccess("Data successfully recorded!");
      } else {
        _showError(responseData['error'] ?? "Server error: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Connection error: ${e.toString()}");
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monitor Robot"),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      backgroundColor: const Color(0xFFF2F2F2),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 18.0, horizontal: 16.0),
                child: Row(
                  children: const [
                    Icon(Icons.battery_full, color: Colors.green, size: 30),
                    SizedBox(width: 12),
                    Text(
                      "Battery Status: 100%",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 14.0),
                child: Row(
                  children: [
                    const Icon(Icons.delete_outline,
                        color: Colors.redAccent, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: binsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Bins Filled",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          border: UnderlineInputBorder(),
                          hintText: "Enter number of filled bins",
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    isSubmitting
                        ? const CircularProgressIndicator()
                        : IconButton(
                            onPressed: addBinRecord,
                            icon: const Icon(Icons.add_circle,
                                color: Colors.green, size: 30),
                            tooltip: "Add bin record",
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Collection History",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : binRecords.isEmpty
                      ? const Center(
                          child: Text(
                            "No bin records yet.",
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                      : ListView.builder(
                          itemCount: binRecords.length,
                          itemBuilder: (context, index) {
                            final record = binRecords[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: const Icon(Icons.history,
                                    color: Colors.deepPurple),
                                title: Text(
                                  "Bins Filled: ${record['bins']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  "Date Collected: ${record['date']}",
                                  style: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}