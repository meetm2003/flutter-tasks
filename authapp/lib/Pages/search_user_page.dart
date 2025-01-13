import 'package:authapp/Services/data_services.dart';
import 'package:flutter/material.dart';

class SearchUserPage extends StatefulWidget {
  final String post;

  const SearchUserPage({super.key, required this.post});

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  final dataServices = DataServices();
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserNamesAndIds();
  }

  Future<void> loadUserNamesAndIds() async {
    try {
      final fetchedUsers = await dataServices.fetchUserNamesAndIds();
      setState(() {
        users = fetchedUsers; // Assign the fetched list of maps (name and id)
        filteredUsers = fetchedUsers; // Filtered list starts as the full list
        isLoading = false; // Loading is complete
      });
    } catch (e) {
      debugPrint("Error loading user names and IDs: $e");
      setState(() {
        isLoading = false; // Handle error by stopping loading indicator
      });
    }
  }

  void filterUsers(String query) async {
    String? currentUserName = await dataServices.getUserNameFromPreferences();

    setState(() {
      filteredUsers = users.where((user) {
        // Only filter if currentUserName is not null, otherwise include all users
        return user['name'].toLowerCase().contains(query.toLowerCase()) &&
            (currentUserName == null || user['name'] != currentUserName);
      }).toList();
    });
  }

  // Call the addInvitation function when ListTile is tapped
  void inviteUser(String inviteeId, String postId, BuildContext context) {
    dataServices.addInvitation(
      inviteeId,
      postId,
      context,
    );
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Shared post successfully..."),
        ),
      ); // Call your invitation function
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search User"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: filterUsers,
                    decoration: const InputDecoration(
                      labelText: "Search by name",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredUsers.isEmpty
                      ? const Center(
                          child: Text("No users found."),
                        )
                      : ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(filteredUsers[index]['name']),
                              onTap: () {
                                // Call inviteUser when ListTile is tapped
                                inviteUser(
                                  filteredUsers[index]['id'],
                                  widget.post,
                                  context,
                                );
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
