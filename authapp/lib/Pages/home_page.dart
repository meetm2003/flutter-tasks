import 'package:authapp/Pages/add_post_page.dart';
import 'package:authapp/Pages/profile_page.dart';
import 'package:authapp/Pages/search_user_page.dart';
import 'package:authapp/Services/data_services.dart';
import 'package:authapp/Widgets/custom_text.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userId;
  final dataServices = DataServices();
  Future<List<Map<String, dynamic>>?>? postsFuture;
  List<Map<String, dynamic>>? sharedPosts;

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  // Fetch the user ID from preferences
  void fetchUserId() async {
    String? fetchedUserId = await dataServices.getUserIdFromAuthUid();
    print("Fetched userId: $fetchedUserId");
    setState(() {
      userId = fetchedUserId; // Update the class-level userId
    });

    // Once userId is fetched, fetch posts
    if (fetchedUserId != null) {
      fetchPosts(fetchedUserId); // Call fetchPosts with the fetched userId
    }
  }

  // Navigate to the profile page
  void goToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ),
    );
  }

  // Fetch posts (both shared and personal)
  Future<void> fetchPosts(String userId) async {
    try {
      // Fetch shared posts for the user
      sharedPosts = await dataServices.fetchSharedPost(userId);

      // Fetch personal posts for the user
      List<Map<String, dynamic>>? personalPosts =
          await dataServices.fetchPostByUserId(userId);

      // Create a list to store all posts
      List<Map<String, dynamic>> allPosts = [];

      // Add personal posts if available
      if (personalPosts != null && personalPosts.isNotEmpty) {
        allPosts.addAll(personalPosts);
      }

      if (sharedPosts != null && sharedPosts!.isNotEmpty) {
        // Extract the post IDs from the shared posts
        List<String> postIds = sharedPosts!
            .map((post) => post['pid'] as String) // Ensure the pid is a String
            .toList();

        // Use the post IDs to fetch post details
        for (String postId in postIds) {
          List<Map<String, dynamic>>? postDetails =
              await dataServices.fetchPostByPostId(postId);
          if (postDetails != null) {
            allPosts.addAll(postDetails); // Add shared posts to the list
          }
        }
      }

      // Update the UI with all posts (personal + shared)
      setState(() {
        postsFuture = Future.value(allPosts);
      });
    } catch (e) {
      debugPrint("Error fetching posts: $e");
      setState(() {
        postsFuture = Future.value([]); // Assign empty list on error
      });
    }
  }

  // Fetch both personal and shared posts on refresh
  Future<void> fetchPostsRefresh() async {
    fetchPosts(userId!);
  }

  // Check if a post is shared
  bool isSharedPost(String postId) {
    return sharedPosts != null &&
        sharedPosts!.any((post) => post['pid'] == postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: "Home", type: TextType.title),
        automaticallyImplyLeading: false,
        actions: [
          Center(
            child: IconButton(
              onPressed: () {
                if (userId != null) fetchPostsRefresh(); // Refresh the posts
              },
              icon: const Icon(Icons.refresh),
            ),
          ),
          Center(
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
              icon: const Icon(Icons.account_circle_rounded),
            ),
          ),
        ],
      ),
      body: userId == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder<List<Map<String, dynamic>>?>(
              // Use FutureBuilder with postsFuture
              future: postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No posts found.'),
                  );
                } else {
                  final posts = snapshot.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final title = post['title'] ?? 'Untitled';
                      final data = post['data'] ?? 'No content';
                      final postId = post['pid'];

                      return GestureDetector(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Share Post"),
                                content: const Text(
                                  "Do you want to share this post?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SearchUserPage(
                                              post:
                                                  postId), // Pass postId as a string
                                        ),
                                      );
                                    },
                                    child: const Text("Yes"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Display the Shared Post tag if it's shared
                                if (isSharedPost(postId))
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Chip(
                                      label: Text('Shared Post'),
                                      backgroundColor: Colors.green,
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                    ),
                                  ),
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  data,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPostPage(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add"),
      ),
    );
  }
}
