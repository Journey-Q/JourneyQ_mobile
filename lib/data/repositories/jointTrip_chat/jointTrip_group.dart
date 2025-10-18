import 'package:firebase_database/firebase_database.dart';
import 'package:journeyq/core/config/firebase_config.dart';

/// Repository for managing Joint Trip Groups in Firebase Realtime Database
///
/// Database Structure:
/// jointTrip_groups/
///   {groupId}/
///     groupId: String
///     groupName: String
///     groupProfile: String (nullable - URL to group image)
///     tripId: int (corresponding trip ID from backend)
///     creatorId: int (user who created the trip)
///     createdAt: timestamp
///     updatedAt: timestamp
///     members: Map<userId, memberData>
///       {userId}/
///         userId: int
///         userName: String
///         userAvatar: String
///         joinedAt: timestamp
///         role: String (creator/member)
class JointTripGroupRepository {
  static final FirebaseConfig _firebaseConfig = FirebaseConfig.instance;

  /// Get reference to jointTrip_groups node
  static DatabaseReference get _groupsRef =>
      _firebaseConfig.getDatabaseReference('jointTrip_groups');

  /// Create a new group when a joint trip is created
  ///
  /// This should be called after the trip is successfully created in backend
  /// groupId should be derived from tripId (e.g., "trip_{tripId}")
  static Future<Map<String, dynamic>> createGroup({
    required int tripId,
    required String groupName,
    required int creatorId,
    required String creatorName,
    required String creatorAvatar,
    String? groupProfile,
  }) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      // Generate groupId from tripId
      final String groupId = 'trip_$tripId';
      final int timestamp = DateTime.now().millisecondsSinceEpoch;

      final groupData = {
        'groupId': groupId,
        'groupName': groupName,
        'groupProfile': groupProfile,
        'tripId': tripId,
        'creatorId': creatorId,
        'createdAt': timestamp,
        'updatedAt': timestamp,
        'members': {
          creatorId.toString(): {
            'userId': creatorId,
            'userName': creatorName,
            'userAvatar': creatorAvatar,
            'joinedAt': timestamp,
            'role': 'creator',
          }
        }
      };

      // Write to Firebase
      await _groupsRef.child(groupId).set(groupData);

      print('✅ Group created successfully: $groupId');
      return groupData;
    } catch (e) {
      print('❌ Error creating group: $e');
      throw Exception('Failed to create group: $e');
    }
  }

  /// Add user to group when they accept a trip request
  static Future<void> addUserToGroup({
    required int tripId,
    required int userId,
    required String userName,
    required String userAvatar,
  }) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      final int timestamp = DateTime.now().millisecondsSinceEpoch;

      final memberData = {
        'userId': userId,
        'userName': userName,
        'userAvatar': userAvatar,
        'joinedAt': timestamp,
        'role': 'member',
      };

      // Add member to group
      await _groupsRef
          .child(groupId)
          .child('members')
          .child(userId.toString())
          .set(memberData);

      // Update group's updatedAt timestamp
      await _groupsRef.child(groupId).child('updatedAt').set(timestamp);

      print('✅ User $userId added to group $groupId');
    } catch (e) {
      print('❌ Error adding user to group: $e');
      throw Exception('Failed to add user to group: $e');
    }
  }

  /// Update group name
  static Future<void> updateGroupName({
    required int tripId,
    required String newGroupName,
  }) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      final int timestamp = DateTime.now().millisecondsSinceEpoch;

      await _groupsRef.child(groupId).update({
        'groupName': newGroupName,
        'updatedAt': timestamp,
      });

      print('✅ Group name updated for $groupId');
    } catch (e) {
      print('❌ Error updating group name: $e');
      throw Exception('Failed to update group name: $e');
    }
  }

  /// Update group profile image
  static Future<void> updateGroupProfile({
    required int tripId,
    required String profileUrl,
  }) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      final int timestamp = DateTime.now().millisecondsSinceEpoch;

      await _groupsRef.child(groupId).update({
        'groupProfile': profileUrl,
        'updatedAt': timestamp,
      });

      print('✅ Group profile updated for $groupId');
    } catch (e) {
      print('❌ Error updating group profile: $e');
      throw Exception('Failed to update group profile: $e');
    }
  }

  /// Remove user from group (leave group)
  /// Users can only leave groups created by others
  static Future<void> leaveGroup({
    required int tripId,
    required int userId,
  }) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';

      // Check if user is the creator
      final snapshot = await _groupsRef.child(groupId).child('creatorId').get();
      if (snapshot.exists && snapshot.value == userId) {
        throw Exception('Creator cannot leave the group. Delete the group instead.');
      }

      // Remove member from group
      await _groupsRef
          .child(groupId)
          .child('members')
          .child(userId.toString())
          .remove();

      // Update group's updatedAt timestamp
      final int timestamp = DateTime.now().millisecondsSinceEpoch;
      await _groupsRef.child(groupId).child('updatedAt').set(timestamp);

      print('✅ User $userId left group $groupId');
    } catch (e) {
      print('❌ Error leaving group: $e');
      throw Exception('Failed to leave group: $e');
    }
  }

  /// Delete group (only creator can delete)
  /// This should also be called when a trip is deleted from backend
  static Future<void> deleteGroup({
    required int tripId,
    required int userId,
  }) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';

      // Verify that user is the creator
      final snapshot = await _groupsRef.child(groupId).child('creatorId').get();
      if (!snapshot.exists) {
        throw Exception('Group not found');
      }

      if (snapshot.value != userId) {
        throw Exception('Only the creator can delete the group');
      }

      // Delete the group
      await _groupsRef.child(groupId).remove();

      print('✅ Group $groupId deleted successfully');
    } catch (e) {
      print('❌ Error deleting group: $e');
      throw Exception('Failed to delete group: $e');
    }
  }

  /// Get group details by tripId
  static Future<Map<String, dynamic>?> getGroupDetails(int tripId) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      final snapshot = await _groupsRef.child(groupId).get();

      if (!snapshot.exists || snapshot.value == null) {
        print('⚠️ Group not found: $groupId');
        return null;
      }

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      print('✅ Group details retrieved for $groupId');
      return data;
    } catch (e) {
      print('❌ Error getting group details: $e');
      throw Exception('Failed to get group details: $e');
    }
  }

  /// Get all members of a group
  static Future<List<Map<String, dynamic>>> getGroupMembers(int tripId) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      final snapshot = await _groupsRef.child(groupId).child('members').get();

      if (!snapshot.exists || snapshot.value == null) {
        print('⚠️ No members found for group: $groupId');
        return [];
      }

      final membersMap = Map<String, dynamic>.from(snapshot.value as Map);
      final membersList = membersMap.values
          .map((member) => Map<String, dynamic>.from(member as Map))
          .toList();

      print('✅ Retrieved ${membersList.length} members for group $groupId');
      return membersList;
    } catch (e) {
      print('❌ Error getting group members: $e');
      throw Exception('Failed to get group members: $e');
    }
  }

  /// Get all groups where user is a member
  static Future<List<Map<String, dynamic>>> getUserGroups(int userId) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final snapshot = await _groupsRef.get();

      if (!snapshot.exists || snapshot.value == null) {
        print('⚠️ No groups found');
        return [];
      }

      final allGroups = Map<String, dynamic>.from(snapshot.value as Map);
      final userGroups = <Map<String, dynamic>>[];

      // Filter groups where user is a member
      allGroups.forEach((groupId, groupData) {
        final group = Map<String, dynamic>.from(groupData as Map);
        final members = group['members'] as Map<dynamic, dynamic>?;

        if (members != null && members.containsKey(userId.toString())) {
          userGroups.add(group);
        }
      });

      print('✅ Found ${userGroups.length} groups for user $userId');
      return userGroups;
    } catch (e) {
      print('❌ Error getting user groups: $e');
      throw Exception('Failed to get user groups: $e');
    }
  }

  /// Get groups created by user (My Groups)
  static Future<List<Map<String, dynamic>>> getCreatedGroups(int userId) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      // Fetch all groups and filter client-side (no index required)
      final snapshot = await _groupsRef.get();

      if (!snapshot.exists || snapshot.value == null) {
        print('⚠️ No groups found');
        return [];
      }

      final allGroups = Map<String, dynamic>.from(snapshot.value as Map);
      final createdGroups = <Map<String, dynamic>>[];

      // Filter groups where user is the creator
      allGroups.forEach((groupId, groupData) {
        final group = Map<String, dynamic>.from(groupData as Map);
        if (group['creatorId'] == userId) {
          createdGroups.add(group);
        }
      });

      print('✅ Found ${createdGroups.length} created groups for user $userId');
      return createdGroups;
    } catch (e) {
      print('❌ Error getting created groups: $e');
      throw Exception('Failed to get created groups: $e');
    }
  }

  /// Get groups user joined (Join Groups - created by others)
  static Future<List<Map<String, dynamic>>> getJoinedGroups(int userId) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final allUserGroups = await getUserGroups(userId);

      // Filter to only include groups where user is not the creator
      final joinedGroups = allUserGroups
          .where((group) => group['creatorId'] != userId)
          .toList();

      print('✅ Found ${joinedGroups.length} joined groups for user $userId');
      return joinedGroups;
    } catch (e) {
      print('❌ Error getting joined groups: $e');
      throw Exception('Failed to get joined groups: $e');
    }
  }

  /// Check if user is member of a group
  static Future<bool> isUserInGroup({
    required int tripId,
    required int userId,
  }) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      final snapshot = await _groupsRef
          .child(groupId)
          .child('members')
          .child(userId.toString())
          .get();

      return snapshot.exists;
    } catch (e) {
      print('❌ Error checking user membership: $e');
      return false;
    }
  }

  /// Listen to group changes (real-time updates)
  static Stream<Map<String, dynamic>?> listenToGroup(int tripId) {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      return _groupsRef.child(groupId).onValue.map((event) {
        if (!event.snapshot.exists || event.snapshot.value == null) {
          return null;
        }
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      });
    } catch (e) {
      print('❌ Error listening to group: $e');
      throw Exception('Failed to listen to group: $e');
    }
  }

  /// Listen to group members changes (real-time updates)
  static Stream<List<Map<String, dynamic>>> listenToGroupMembers(int tripId) {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      return _groupsRef.child(groupId).child('members').onValue.map((event) {
        if (!event.snapshot.exists || event.snapshot.value == null) {
          return <Map<String, dynamic>>[];
        }

        final membersMap = Map<String, dynamic>.from(event.snapshot.value as Map);
        return membersMap.values
            .map((member) => Map<String, dynamic>.from(member as Map))
            .toList();
      });
    } catch (e) {
      print('❌ Error listening to group members: $e');
      throw Exception('Failed to listen to group members: $e');
    }
  }

  /// Remove member from group (only creator can remove)
  static Future<void> removeMember({
    required int tripId,
    required int creatorId,
    required int memberIdToRemove,
  }) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';

      // Verify that requester is the creator
      final snapshot = await _groupsRef.child(groupId).child('creatorId').get();
      if (!snapshot.exists) {
        throw Exception('Group not found');
      }

      if (snapshot.value != creatorId) {
        throw Exception('Only the creator can remove members');
      }

      // Cannot remove creator
      if (memberIdToRemove == creatorId) {
        throw Exception('Cannot remove the creator from the group');
      }

      // Remove member
      await _groupsRef
          .child(groupId)
          .child('members')
          .child(memberIdToRemove.toString())
          .remove();

      // Update group's updatedAt timestamp
      final int timestamp = DateTime.now().millisecondsSinceEpoch;
      await _groupsRef.child(groupId).child('updatedAt').set(timestamp);

      print('✅ Member $memberIdToRemove removed from group $groupId');
    } catch (e) {
      print('❌ Error removing member: $e');
      throw Exception('Failed to remove member: $e');
    }
  }
}
