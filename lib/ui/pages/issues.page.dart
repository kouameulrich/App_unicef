// ignore_for_file: deprecated_member_use, unused_local_variable, unused_field

import 'package:flutter/material.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/issues.dart';
import 'package:http/http.dart' as http;
import 'package:unicefapp/ui/pages/S&L.page.dart';
import 'package:unicefapp/ui/pages/issues.details.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'dart:convert';

import 'package:unicefapp/widgets/mydrawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IssuesPage extends StatefulWidget {
  const IssuesPage({super.key});

  @override
  _IssuesPageState createState() => _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> {
  List<Issue> tableData = [];

  final storage = locator<TokenStorageService>();
  late final Future<Agent?> _futureAgentConnected;
  String userCountry = '';
  String BASEURL = 'https://www.trackiteum.org';
  // bool selected = true;

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    _futureAgentConnected.then((agent) {
      if (agent != null) {
        setState(() {
          userCountry = agent.country;
        });
        _fetchIssue(userCountry);
      }
    });
    super.initState();
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  void _fetchIssue(String userCountry) async {
    // Effectuer l'appel à l'API pour récupérer les données du tableau
    var response = await http
        .get(Uri.parse('$BASEURL/u/admin/issues/$userCountry'), headers: {
      "Content-type": "application/json",
    });
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<Issue> data = [];

      for (var item in jsonResponse) {
        var apiResponse = Issue.fromJson(item);
        data.add(apiResponse);
      }

      setState(() {
        tableData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.blueFondCadre,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Defaults.white,
          centerTitle: false,
          leading: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SupplyLogisticPage()),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Defaults.bluePrincipal,
                  )),
            ],
          ),
          title: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.issueTitle,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                AppLocalizations.of(context)!.issueSub,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Image.asset(
                'images/unicef1.png',
                width: 100.0,
                height: 100.0,
              ),
              onPressed: () {
                // Actions à effectuer lorsque le bouton est pressé
              },
            ),
          ],
        ),
      ),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  dividerThickness: 5,
                  dataRowHeight: 50,
                  showBottomBorder: true,
                  headingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Defaults.bluePrincipal),
                  headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => Defaults.white),
                  columns: [
                    DataColumn(
                        label: Text(AppLocalizations.of(context)!.ipName)),
                    DataColumn(
                        label: Text(AppLocalizations.of(context)!.ipReceiver)),
                    DataColumn(
                        label: Text(AppLocalizations.of(context)!.driver)),
                    DataColumn(
                        label: Text(AppLocalizations.of(context)!.receivedOn)),
                    DataColumn(
                        label: Text(AppLocalizations.of(context)!.sendQty)),
                    DataColumn(
                        label: Text(AppLocalizations.of(context)!.qtyReceived)),
                    DataColumn(
                        label: Text(AppLocalizations.of(context)!.status)),
                  ],
                  rows: tableData.map((data) {
                    return DataRow(
                        onLongPress: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IssuesDetailsPage(
                                        issue: data,
                                      )));
                        },
                        cells: [
                          DataCell(Text(data.ipName)),
                          DataCell(Text(data.ipReceiver)),
                          DataCell(Text(data.driver)),
                          DataCell(Text(data.dateOfReception)),
                          DataCell(Text(data.sentQuantity.toString())),
                          DataCell(Text(data.reportedQuantity.toString())),
                          DataCell(Text(data.status)),
                        ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
