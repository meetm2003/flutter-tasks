import 'package:authapp/Auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DataServices {
  final SupabaseClient _supabase = Supabase.instance.client;

  // get AuthServices class
  final authServices = AuthServices();

  // USER TABLE
  // insert data in User table
  Future addUser(
      String name, var dob, String phoneNumber, BuildContext context) async {
    try {
      // Call the function to get current user AuthId
      final authId = authServices.getCurrentUserId();
      print(authId);

      return await _supabase.from("User").insert({
        "name": name,
        "date_of_birth": dob,
        "phone_number": phoneNumber,
        "auth_uid": authId
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  // get user table
  Future fetchTable(BuildContext context) async {
    try {
      return await _supabase.from("User").select();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  // get user id
  Future<String?> getUserIdFromAuthUid() async {
    final String? authId =
        await authServices.getCurrentUserId(); // Get current auth user ID
    try {
      final response = await _supabase
          .from('User') // Replace with your actual table name if different
          .select(
              'id') // Replace 'userId' with the actual column name for user ID
          .eq('auth_uid',
              authId!) // Use the correct column name that holds the auth ID in your table
          .single(); // Ensure it fetches a single result

      if (response != null) {
        return response['id']; // Return userId from the response
      } else {
        debugPrint("No user found for authUid: $authId");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching userId for authUid: $authId. Error: $e");
      return null;
    }
  }

  // get user using auth_id
  Future<Map<String, dynamic>?> fetchUserByAuthId(String authUid) async {
    try {
      final response = await _supabase
          .from("User")
          .select()
          .eq("auth_uid", authUid)
          .maybeSingle();

      if (response == null) {
        debugPrint("No user found for auth_uid: $authUid");
        return null;
      } else {
        debugPrint("User details: $response");
        return response;
      }
    } catch (e) {
      debugPrint("Error fetching user by auth_uid: $e");
      return null;
    }
  }

  // fetch user name and id list
  Future<List<Map<String, dynamic>>> fetchUserNamesAndIds() async {
    try {
      final response = await _supabase
          .from('User')
          .select('id, name')
          .order('name', ascending: true);

      // Check if the response is empty
      if (response == null || response.isEmpty) {
        return [];
      }

      // Extract and return name and id as a list of maps
      return response.map<Map<String, dynamic>>((user) {
        return {
          'id': user['id'],
          'name': user['name'],
        };
      }).toList();
    } catch (e) {
      debugPrint("Error fetching user names and IDs: $e");
      return [];
    }
  }

  // POST TABLE
  // insert data in post table
  Future addPost(String title, String data, BuildContext context) async {
    try {
      // Call the function to get current userid
      String? userId = await getUserIdFromAuthUid();

      return await _supabase.from("post").insert({
        "uid": userId,
        "title": title,
        "data": data,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  // get post table
  Future fetchPostTable(BuildContext context) async {
    try {
      return await _supabase.from("post").select();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  // get posts using userid
  Future<List<Map<String, dynamic>>?> fetchPostByUserId(String userid) async {
    try {
      final response = await _supabase.from("post").select().eq("uid", userid);

      if (response == null) {
        debugPrint("No post found for userid: $userid");
        return null;
      } else {
        debugPrint("post details: $response");
        return response;
      }
    } catch (e) {
      debugPrint("Error fetching user by userid: $e");
      return null;
    }
  }

  // get posts using postid
  Future<List<Map<String, dynamic>>?> fetchPostByPostId(String postid) async {
    try {
      final response = await _supabase.from("post").select().eq("pid", postid);

      if (response == null) {
        debugPrint("No post found for userid: $postid");
        return null;
      } else {
        debugPrint("post fetcing postId details: $response");
        return response;
      }
    } catch (e) {
      debugPrint("Error fetching user by userid: $e");
      return null;
    }
  }

  // Invitation table
  // insert the data into invetation table
  Future addInvitation(
      String inviteeId, String postId, BuildContext context) async {
    try {
      // Call the function to get current userid
      String? userId = await getUserIdFromAuthUid();
      print("userId : $userId");

      return await _supabase.from("invitation").insert({
        "inviter_id": userId,
        "invitee_id": inviteeId,
        "pid": postId,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
      debugPrint(e.toString());
    }
  }

  // fetch shared posts from invitation table
  Future<List<Map<String, dynamic>>?> fetchSharedPost(String userid) async {
    try {
      final response =
          await _supabase.from("invitation").select().eq("invitee_id", userid);

      if (response == null) {
        debugPrint("No shared post found for userid: $userid");
        return null;
      } else {
        debugPrint("shared post details: $response");
        return response;
      }
    } catch (e) {
      debugPrint("Error fetching user by userid: $e");
      return null;
    }
  }

  // get userId from Sharedpreferences
  Future<String?> getUserIdFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  // get userName from Sharedpreferences
  Future<String?> getUserNameFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  // get userDob from Sharedpreferences
  Future<String?> getUserDobFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userDob');
  }

  // get userPhone from Sharedpreferences
  Future<String?> getUserPhoneNoFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userPhoneNo');
  }
}
