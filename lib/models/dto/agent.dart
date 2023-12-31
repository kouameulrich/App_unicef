// ignore_for_file: unused_local_variable, unused_import

import 'package:unicefapp/models/dto/roles.dart';

class Agent {
  late String id;
  late String username;
  late String email;
  late String telephone;
  late String firstname;
  late String lastname;
  late List<String> roles;
  late String accessToken;
  late String organisation;
  late String country;

  Agent(
      {required this.id,
      required this.username,
      required this.email,
      required this.telephone,
      required this.firstname,
      required this.lastname,
      required this.roles,
      required this.accessToken,
      required this.organisation,
      required this.country});

  @override
  String toString() {
    return 'Agent{id: $id, username: $username, email: $email, telephone: $telephone, firstname: $firstname, lastname: $lastname, roles: $roles, accessToken: $accessToken, organisation: $organisation, country: $country}';
  }

  Agent.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? ''; // Provide a default value if 'id' is null
    username = json['username'] ?? '';
    email = json['email'] ?? '';
    telephone = json['telephone'] ?? '';
    firstname = json['firstname'] ?? '';
    lastname = json['lastname'] ?? '';

    var roleObjsJson = json['roles'] as List? ?? [];
    // Use null-aware spread to handle null case
    List<String> _roles = List<String>.from(roleObjsJson);

    accessToken = json['accessToken'] ?? '';
    organisation = json['organisation'] ?? '';
    roles = _roles;
    country = json['country'] ?? '';
  }
}
