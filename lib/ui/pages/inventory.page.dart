// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/issues.dart';
import 'package:http/http.dart' as http;
import 'package:unicefapp/models/dto/stock.dart';
import 'package:unicefapp/ui/pages/S&L.page.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/ui/pages/issues.details.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'dart:convert';

import 'package:unicefapp/widgets/mydrawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Stock> tableData = [];
  final storage = locator<TokenStorageService>();
  late final Future<Agent?> _futureAgentConnected;
  String userCountry = '';
  String BASEURL = 'https://www.trackiteum.org';
  // bool selected = true;

  @override
  void initState() {
    super.initState();
    _futureAgentConnected = getAgent();
    _futureAgentConnected.then((value) {
      if (value != null) {
        _getInventory(
            // value.roles.elementAt(0) == 'ROLE_IP' ? value.organisation : 'all',
            value.country);
      }
    });
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  void _getInventory(String userCountry) async {
    // Effectuer l'appel à l'API pour récupérer les données du tableau
    var response = await http.get(
      Uri.parse('$BASEURL/u/admin/inventory/$userCountry'),
      headers: {
        "Content-type": "application/json",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<Stock> data = [];

      for (var item in jsonResponse) {
        var apiResponse = Stock.fromJson(item);
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
                      MaterialPageRoute(builder: (context) => const HomePage()),
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
                AppLocalizations.of(context)!.inventoryTitle,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                AppLocalizations.of(context)!.inventorySubTitle,
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
              child: DataTable(
                horizontalMargin: 22,
                dividerThickness: 3,
                dataRowHeight: 60,
                showBottomBorder: true,
                headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold, color: Defaults.bluePrincipal),
                headingRowColor: MaterialStateProperty.resolveWith(
                    (states) => Defaults.white),
                columns: [
                  DataColumn(
                      label: Text(AppLocalizations.of(context)!.material)),
                  DataColumn(
                      label: Text(
                          AppLocalizations.of(context)!.materialDescription)),
                  DataColumn(label: Text(AppLocalizations.of(context)!.qty)),
                ],
                rows: tableData.map((data) {
                  return DataRow(cells: [
                    DataCell(Text(data.material)),
                    DataCell(Text(data.materialDescription)),
                    DataCell(Text(data.quantity)),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
