// lib/features/profile/presentation/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ════════════════════════════════════════════════════════════════════════════════
// NAV ITEM MODEL
// ════════════════════════════════════════════════════════════════════════════════

class _NavItem {
  final String label;
  final String asset;
  const _NavItem({required this.label, required this.asset});
}

// ════════════════════════════════════════════════════════════════════════════════
// SHARED BOTTOM NAV MIXIN
// ════════════════════════════════════════════════════════════════════════════════

const _navItems = [
  _NavItem(label: 'Home',    asset: 'assets/Home.png'),
  _NavItem(label: 'History', asset: 'assets/Clipboard.png'),
  _NavItem(label: 'Learn',   asset: 'assets/Book open.png'),
  _NavItem(label: 'Profile', asset: 'assets/person.png'),
];

const _primaryColor = Color(0xFF1A7A9B);
const _navInactive  = Color(0xFFB0BEC5);
const _teal         = Color(0xFF26A69A);

Widget buildBottomNav(BuildContext context, int currentIndex, StateSetter setState) {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, -4))],
    ),
    child: SafeArea(
      top: false,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_navItems.length, (index) {
            final item = _navItems[index];
            final isActive = currentIndex == index;
            return GestureDetector(
              onTap: () {
                switch (index) {
                  case 0: context.go('/home'); break;
                  case 1: context.go('/history'); break;
                  case 2: context.go('/learn'); break;
                  case 3: context.go('/profile'); break;
                }
              },
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 64, height: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        isActive ? _primaryColor : _navInactive, BlendMode.srcIn),
                      child: Image.asset(item.asset, height: 26, width: 26, fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 4),
                    Text(item.label, style: TextStyle(
                      fontSize: 10,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                      color: isActive ? _primaryColor : _navInactive,
                    )),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    ),
  );
}

// ════════════════════════════════════════════════════════════════════════════════
// MODELS
// ════════════════════════════════════════════════════════════════════════════════

class UserProfile {
  String firstName;
  String lastName;
  String age;
  String gender;
  String email;
  String phoneNumber;
  String address;

  UserProfile({
    this.firstName = 'test ',
    this.lastName = 'Acuvia',
    this.age = '25',
    this.gender = 'Male',
    this.email = 'Acuvianto@gmail.com',
    this.phoneNumber = '0912 345 6789',
    this.address = '123 Main St, City',
  });

  String get fullName => '$firstName $lastName';
}

class EmergencyContact {
  final String name;
  final String phone;
  final String? avatarAsset;

  const EmergencyContact({
    required this.name,
    required this.phone,
    this.avatarAsset,
  });
}

// Shared state (replace with Riverpod provider in production)
final _userProfile = UserProfile();
final _contacts = <EmergencyContact>[
  const EmergencyContact(name: 'Alpha', phone: '0912 345 6789'),
  const EmergencyContact(name: 'Alpha', phone: '0912 345 6789'),
  const EmergencyContact(name: 'Alpha', phone: '0912 345 6789'),
  const EmergencyContact(name: 'Alpha', phone: '0912 345 6789'),
  const EmergencyContact(name: 'Alpha', phone: '0912 345 6789'),
];

// ════════════════════════════════════════════════════════════════════════════════
// 1. MY PROFILE SCREEN  (main profile hub)
// ════════════════════════════════════════════════════════════════════════════════

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: buildBottomNav(context, _currentIndex, setState),
      body: SafeArea(
        child: Column(
          children: [
            // ── App bar ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
              child: Row(
                children: [
                  const Spacer(),
                  const Text('My Profile',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111111))),
                  const Spacer(),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Avatar + name + email ────────────────────────────────────
            Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: const Color(0xFFE0F2F1),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/avatar.png',
                      width: 84, height: 84, fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                          Icons.person_rounded, size: 48, color: _teal),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(_userProfile.fullName,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111))),
                const SizedBox(height: 4),
                Text(_userProfile.email,
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF9E9E9E))),
              ],
            ),

            const SizedBox(height: 28),

            // ── Menu items ───────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    _MenuItem(
                      icon: Icons.person_outline_rounded,
                      label: 'User Profile',
                      onTap: () async {
                        await Navigator.push(context, MaterialPageRoute(
                            builder: (_) => const UserProfileScreen()));
                        setState(() {}); // refresh name/email if edited
                      },
                    ),
                    _MenuItem(
                      icon: Icons.add_box_outlined,
                      label: 'Medical Information',
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => const MedicalInformationScreen())),
                    ),
                    _MenuItem(
                      icon: Icons.access_time_outlined,
                      label: 'Emergency',
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => const EmergencyScreen())),
                    ),
                    _MenuItem(
                      icon: Icons.phone_outlined,
                      label: 'Contacts',
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => const ContactsScreen())),
                    ),
                    _MenuItem(
                      icon: Icons.help_outline_rounded,
                      label: 'FAQs about Acuvia',
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => const FaqScreen())),
                    ),
                  ],
                ),
              ),
            ),

            // ── Logout button ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.go('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, size: 20),
                      SizedBox(width: 10),
                      Text('Logout',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      SizedBox(width: 10),
                      Icon(Icons.chevron_right_rounded, size: 22),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// 2. USER PROFILE SCREEN  (view mode)
// ════════════════════════════════════════════════════════════════════════════════

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, 'User Profile', actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: OutlinedButton.icon(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const EditProfileScreen()));
              setState(() {});
            },
            icon: const Icon(Icons.edit_outlined, size: 15),
            label: const Text('Edit Profile',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              foregroundColor: _teal,
              side: const BorderSide(color: _teal),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            ),
          ),
        ),
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Center(
              child: CircleAvatar(
                radius: 46,
                backgroundColor: const Color(0xFFE0F2F1),
                child: ClipOval(
                  child: Image.asset('assets/avatar.png',
                      width: 92, height: 92, fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                          Icons.person_rounded, size: 52, color: _teal)),
                ),
              ),
            ),
            const SizedBox(height: 28),
            _ViewField(label: 'First Name',   value: _userProfile.firstName),
            _ViewField(label: 'Last Name',    value: _userProfile.lastName),
            _ViewField(label: 'Age',          value: _userProfile.age),
            _ViewField(label: 'Gender',       value: _userProfile.gender),
            _ViewField(label: 'Email',        value: _userProfile.email),
            _ViewField(label: 'Phone Number', value: _userProfile.phoneNumber),
            _ViewField(label: 'Address',      value: _userProfile.address),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// 3. EDIT PROFILE SCREEN
// ════════════════════════════════════════════════════════════════════════════════

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _age;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  String _gender = _userProfile.gender;

  static const _genderOptions = ['Male', 'Female', 'Non-binary', 'Prefer not to say'];

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController(text: _userProfile.firstName);
    _lastName  = TextEditingController(text: _userProfile.lastName);
    _age       = TextEditingController(text: _userProfile.age);
    _email     = TextEditingController(text: _userProfile.email);
    _phone     = TextEditingController(text: _userProfile.phoneNumber);
    _address   = TextEditingController(text: _userProfile.address);
  }

  @override
  void dispose() {
    for (final c in [_firstName, _lastName, _age, _email, _phone, _address]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    _userProfile.firstName   = _firstName.text.trim();
    _userProfile.lastName    = _lastName.text.trim();
    _userProfile.age         = _age.text.trim();
    _userProfile.gender      = _gender;
    _userProfile.email       = _email.text.trim();
    _userProfile.phoneNumber = _phone.text.trim();
    _userProfile.address     = _address.text.trim();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, 'Edit  Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with edit icon
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: const Color(0xFFE0F2F1),
                    child: ClipOval(
                      child: Image.asset('assets/avatar.png',
                          width: 92, height: 92, fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Icon(
                              Icons.person_rounded, size: 52, color: _teal)),
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 28, height: 28,
                      decoration: const BoxDecoration(
                          color: _teal, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt_outlined,
                          color: Colors.white, size: 15),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // First + Last name row
            Row(
              children: [
                Expanded(child: _EditField(label: 'First Name', controller: _firstName)),
                const SizedBox(width: 12),
                Expanded(child: _EditField(label: 'Last Name',  controller: _lastName)),
              ],
            ),
            // Age + Gender row
            Row(
              children: [
                Expanded(child: _EditField(label: 'Age', controller: _age, keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(
                  child: _GenderDropdown(
                    value: _gender,
                    options: _genderOptions,
                    onChanged: (v) => setState(() => _gender = v ?? _gender),
                  ),
                ),
              ],
            ),
            _EditField(label: 'Email',        controller: _email, keyboardType: TextInputType.emailAddress),
            _EditField(label: 'Phone Number', controller: _phone, keyboardType: TextInputType.phone),
            _EditField(label: 'Address',      controller: _address),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  elevation: 0,
                ),
                child: const Text('Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// 4. EMERGENCY SCREEN
// ════════════════════════════════════════════════════════════════════════════════

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  static const _hotlines = [
    _Hotline(name: 'National Emergency',       number: '911',       color: Color(0xFFE53935)),
    _Hotline(name: 'Philippine Red Cross',     number: '143',       color: Color(0xFFE53935)),
    _Hotline(name: 'Bureau of Fire Protection',number: '160',       color: Color(0xFFFF8F00)),
    _Hotline(name: 'PNP Hotline',              number: '117',       color: Color(0xFF1A7A9B)),
    _Hotline(name: 'NDRRMC Hotline',           number: '02-8911-5061', color: Color(0xFF43A047)),
    _Hotline(name: 'DOH Health Emergency',     number: '1555',      color: Color(0xFF26A69A)),
    _Hotline(name: 'Poison Control Center',    number: '02-8524-1078', color: Color(0xFF7B1FA2)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, 'Emergency'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE53935).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                      color: const Color(0xFFE53935).withValues(alpha: 0.12),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.warning_amber_rounded,
                      color: Color(0xFFE53935), size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('In case of emergency',
                          style: TextStyle(
                              color: Color(0xFFE53935),
                              fontSize: 14, fontWeight: FontWeight.w700)),
                      SizedBox(height: 3),
                      Text('Call the appropriate hotline immediately. Stay calm and provide your location.',
                          style: TextStyle(color: Color(0xFF5D4037), fontSize: 12, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Emergency Hotlines',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF111111))),
          const SizedBox(height: 12),
          ..._hotlines.map((h) => _HotlineTile(hotline: h)),
        ],
      ),
    );
  }
}

class _Hotline {
  final String name;
  final String number;
  final Color color;
  const _Hotline({required this.name, required this.number, required this.color});
}

class _HotlineTile extends StatelessWidget {
  final _Hotline hotline;
  const _HotlineTile({required this.hotline});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hotline.color.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
                color: hotline.color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(Icons.phone_rounded, color: hotline.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hotline.name,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: Color(0xFF111111))),
                const SizedBox(height: 2),
                Text(hotline.number,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                        color: hotline.color)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                  color: hotline.color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(Icons.call_rounded, color: hotline.color, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// 5. CONTACTS SCREEN
// ════════════════════════════════════════════════════════════════════════════════

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});
  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final List<EmergencyContact> _list = List.from(_contacts);

  void _addContact() {
    final nameCtrl  = TextEditingController();
    final phoneCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add New Contact',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 8),
            TextField(controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _teal, foregroundColor: Colors.white),
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                setState(() => _list.add(EmergencyContact(
                    name: nameCtrl.text.trim(),
                    phone: phoneCtrl.text.trim())));
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, 'Contacts'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: [
          // Add button
          GestureDetector(
            onTap: _addContact,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: const BoxDecoration(color: _teal, shape: BoxShape.circle),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text('Add New Contact (${_list.length})',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                          color: _teal)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          ..._list.map((c) => _ContactTile(
            contact: c,
            onDelete: () => setState(() => _list.remove(c)),
          )),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final EmergencyContact contact;
  final VoidCallback onDelete;
  const _ContactTile({required this.contact, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFE0F2F1),
            child: ClipOval(
              child: Image.asset('assets/avatar.png',
                  width: 44, height: 44, fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const Icon(Icons.person_rounded, color: _teal, size: 24)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                        color: Color(0xFF111111))),
                const SizedBox(height: 2),
                Text(contact.phone,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF757575))),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                  color: _teal.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.phone_outlined, color: _teal, size: 18),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE), shape: BoxShape.circle),
              child: const Icon(Icons.delete_outline_rounded,
                  color: Color(0xFFE53935), size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// 6. FAQ SCREEN
// ════════════════════════════════════════════════════════════════════════════════

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});
  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int? _expanded;

  static const _faqs = [
    _Faq(
      question: 'What is Acuvia?',
      answer: 'Acuvia is an AI-powered smart patient triage assistant designed to help users assess the urgency of their symptoms and receive health guidance.',
    ),
    _Faq(
      question: 'How does Acuvia work?',
      answer: 'Users enter their symptoms, and Acuvia analyzes the information using AI to classify the situation as:\n\n• Non-Urgent\n• Urgent\n• Emergency\n\nThe app then provides recommended next steps.',
    ),
    _Faq(
      question: 'Is Acuvia a replacement for a doctor?',
      answer: 'No. Acuvia does not replace licensed healthcare professionals. It is intended for informational and guidance purposes only.',
    ),
    _Faq(
      question: 'Can Acuvia diagnose illnesses?',
      answer: 'No. Acuvia does not provide official medical diagnoses. It only evaluates symptom urgency and offers general health guidance.',
    ),
    _Faq(
      question: 'What should I do during an emergency result?',
      answer: 'If Acuvia indicates an emergency result, seek immediate medical attention or contact emergency services right away.',
    ),
    _Faq(
      question: 'Is my health information private?',
      answer: 'Acuvia is designed to prioritize user privacy and secure handling of health-related information.',
    ),
    _Faq(
      question: 'Who can use Acuvia?',
      answer: 'Anyone seeking quick health guidance and symptom urgency assessment can use Acuvia.',
    ),
    _Faq(
      question: 'What types of symptoms can Acuvia assess?',
      answer: 'Acuvia can assess common symptoms such as:\n\n• Fever\n• Cough\n• Headache\n• Chest discomfort\n• Difficulty breathing\n• Fatigue\n• Nausea\n• Body pain',
    ),
    _Faq(
      question: 'Can Acuvia work 24/7?',
      answer: 'Yes. Acuvia is designed to provide assistance anytime and anywhere with internet access.',
    ),
    _Faq(
      question: 'What should I do if symptoms worsen?',
      answer: 'Seek professional medical care immediately if symptoms become severe or rapidly worsen.',
    ),
    _Faq(
      question: 'Does Acuvia provide treatment or prescriptions?',
      answer: 'No. Acuvia does not prescribe medication or provide medical treatment plans.',
    ),
    _Faq(
      question: 'Why is triage important?',
      answer: 'Triage helps determine how urgently a person needs medical attention, allowing faster response to serious conditions.',
    ),
    _Faq(
      question: 'Can Acuvia help reduce unnecessary hospital visits?',
      answer: 'Acuvia aims to help users better understand symptom urgency, which may support more informed healthcare decisions.',
    ),
    _Faq(
      question: 'Is Acuvia suitable for children?',
      answer: 'A parent or guardian should supervise use for minors, and serious symptoms should always be evaluated by healthcare professionals.',
    ),
    _Faq(
      question: 'Does Acuvia require internet access?',
      answer: 'Some AI features may require an internet connection to function properly.',
    ),
    _Faq(
      question: 'How accurate is Acuvia?',
      answer: 'Acuvia aims to provide reliable guidance, but AI assessments may not always be fully accurate. Professional medical evaluation is still recommended when necessary.',
    ),
    _Faq(
      question: 'Why does Acuvia ask follow-up questions?',
      answer: 'Follow-up questions help the AI better understand symptoms and improve urgency assessment accuracy.',
    ),
    _Faq(
      question: 'Can I use Acuvia for mental health concerns?',
      answer: 'Acuvia may provide general wellness guidance, but mental health emergencies should always be handled by qualified professionals or emergency services.',
    ),
    _Faq(
      question: 'What makes Acuvia different?',
      answer: 'Acuvia combines AI-powered symptom analysis, urgency classification, and user-friendly healthcare guidance in one accessible platform.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, 'FAQs about Acuvia'),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
        itemCount: _faqs.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final faq = _faqs[index];
          final isOpen = _expanded == index;
          return GestureDetector(
            onTap: () => setState(() => _expanded = isOpen ? null : index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isOpen ? _primaryColor.withValues(alpha: 0.5) : const Color(0xFFE0E0E0)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                    child: Row(
                      children: [
                        Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(
                            color: _primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text('${index + 1}',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700,
                                    color: _primaryColor)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(faq.question,
                              style: const TextStyle(fontSize: 14,
                                  fontWeight: FontWeight.w600, color: Color(0xFF111111))),
                        ),
                        AnimatedRotation(
                          turns: isOpen ? 0.5 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: Icon(Icons.keyboard_arrow_down_rounded,
                              color: isOpen ? _primaryColor : const Color(0xFF9E9E9E), size: 22),
                        ),
                      ],
                    ),
                  ),
                  if (isOpen) ...[
                    Divider(color: _primaryColor.withValues(alpha: 0.15), height: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                      child: Text(faq.answer,
                          style: const TextStyle(fontSize: 13, color: Color(0xFF424242), height: 1.55)),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Faq {
  final String question;
  final String answer;
  const _Faq({required this.question, required this.answer});
}

// ════════════════════════════════════════════════════════════════════════════════
// 7. MEDICAL INFORMATION SCREEN  (bonus — referenced in menu)
// ════════════════════════════════════════════════════════════════════════════════

class MedicalInformationScreen extends StatefulWidget {
  const MedicalInformationScreen({super.key});
  @override
  State<MedicalInformationScreen> createState() => _MedicalInformationScreenState();
}

class _MedicalInformationScreenState extends State<MedicalInformationScreen> {
  final _bloodTypeCtrl   = TextEditingController(text: 'O+');
  final _allergiesCtrl   = TextEditingController(text: 'Penicillin, Peanuts');
  final _conditionsCtrl  = TextEditingController(text: 'Hypertension');
  final _medicationsCtrl = TextEditingController(text: 'Amlodipine 5mg');
  final _weightCtrl      = TextEditingController(text: '70');
  final _heightCtrl      = TextEditingController(text: '175');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, 'Medical Information'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _EditField(label: 'Blood Type',          controller: _bloodTypeCtrl),
            _EditField(label: 'Allergies',           controller: _allergiesCtrl),
            _EditField(label: 'Existing Conditions', controller: _conditionsCtrl),
            _EditField(label: 'Current Medications', controller: _medicationsCtrl),
            Row(
              children: [
                Expanded(child: _EditField(label: 'Weight (kg)', controller: _weightCtrl,
                    keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: _EditField(label: 'Height (cm)', controller: _heightCtrl,
                    keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Medical information saved!')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  elevation: 0,
                ),
                child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// SHARED SMALL WIDGETS
// ════════════════════════════════════════════════════════════════════════════════

PreferredSizeWidget _buildAppBar(BuildContext context, String title,
    {List<Widget>? actions}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded,
          color: Color(0xFF111111), size: 18),
      onPressed: () => Navigator.pop(context),
    ),
    title: Text(title,
        style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF111111))),
    actions: actions,
  );
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF757575), size: 20),
            const SizedBox(width: 14),
            Expanded(child: Text(label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                    color: Color(0xFF111111)))),
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFFBDBDBD), size: 20),
          ],
        ),
      ),
    );
  }
}

class _ViewField extends StatelessWidget {
  final String label;
  final String value;
  const _ViewField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                    color: Color(0xFF111111))),
          ),
        ],
      ),
    );
  }
}

class _GenderDropdown extends StatelessWidget {
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _GenderDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gender',
              style: TextStyle(fontSize: 12, color: Color(0xFF9E9E9E))),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: value,
            items: options
                .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                .toList(),
            onChanged: onChanged,
            style: const TextStyle(fontSize: 14, color: Color(0xFF111111)),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _teal, width: 1.4)),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const _EditField({
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E))),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14, color: Color(0xFF111111)),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _teal, width: 1.4)),
            ),
          ),
        ],
      ),
    );
  }
}