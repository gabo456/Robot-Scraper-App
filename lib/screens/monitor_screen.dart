import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  final binsController = TextEditingController();
  final List<Map<String, String>> binRecords = [];

  void addBinRecord() {
    if (binsController.text.isEmpty) return;

    String bins = binsController.text;
    String date = DateFormat('MM/dd/yy').format(DateTime.now());

    setState(() {
      binRecords.insert(0, {"bins": bins, "date": date});
      binsController.clear();
    });
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
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
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
              child: binRecords.isEmpty
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
