import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tableau de Bord',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().signOut();
              if (context.mounted) context.go('/login');
            },
            icon: Icon(
              Icons.logout_rounded,
              color: Colors.white.withOpacity(0.9),
              size: 28,
            ),
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF6A11CB).withOpacity(0.1),
                const Color(0xFF2575FC).withOpacity(0.1),
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 180,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(Icons.person_rounded, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.displayName ?? user?.email ?? 'Utilisateur',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '',
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(context, Icons.dashboard_rounded, 'Tableau de bord', () => Navigator.pop(context), isSelected: true),
              _buildDrawerItem(context, Icons.person_rounded, 'Profil', () => Navigator.pop(context)),
              _buildDrawerItem(context, Icons.settings_rounded, 'Paramètres', () => Navigator.pop(context)),
              _buildDrawerItem(context, Icons.help_rounded, 'Aide', () => Navigator.pop(context)),
              const Divider(height: 32),
              _buildDrawerItem(context, Icons.logout_rounded, 'Déconnexion', () async {
                Navigator.pop(context);
                await AuthService().signOut();
                if (context.mounted) context.go('/login');
              }, color: Colors.red.shade600),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Card avec Glassmorphism
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white.withOpacity(0.1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.waving_hand_rounded, size: 32, color: Colors.white),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Bonjour,', style: TextStyle(color: Colors.grey.shade300, fontSize: 18)),
                                    const SizedBox(height: 4),
                                    Text(
                                      user?.displayName ?? user?.email ?? 'Utilisateur',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Bienvenue sur votre espace personnel. Profitez d\'une expérience optimale !',
                                      style: TextStyle(color: Colors.grey.shade400, fontSize: 14, height: 1.4),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Quick Actions Grid
                Text('Actions rapides', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildActionCard(context, 'Profil', Icons.person_rounded, Colors.blueAccent, () {}),
                    _buildActionCard(context, 'Paramètres', Icons.settings_rounded, Colors.greenAccent, () {}),
                    _buildActionCard(context, 'Aide', Icons.help_rounded, Colors.orangeAccent, () {}),
                    _buildActionCard(context, 'Support', Icons.support_rounded, Colors.purpleAccent, () {}),
                  ],
                ),

                const SizedBox(height: 32),

                // Stats Section
                Text('Statistiques', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildStatCard('Connexions', '12', Icons.login_rounded, Colors.tealAccent)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatCard('Messages', '5', Icons.message_rounded, Colors.indigoAccent)),
                  ],
                ),

                const SizedBox(height: 32),

                // Motivational Section
                Center(
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1000),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.scale(
                          scale: value,
                          child: Column(
                            children: [
                              Icon(Icons.rocket_launch_rounded, size: 80, color: const Color(0xFF6A11CB)),
                              const SizedBox(height: 16),
                              Text(
                                'Votre aventure commence ici',
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Explorez les fonctionnalités et profitez de la meilleure expérience possible.',
                                  style: TextStyle(color: Colors.grey.shade400, fontSize: 14, height: 1.4),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap,
      {bool isSelected = false, Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? (isSelected ? Colors.blueAccent : Colors.grey.shade400), size: 24),
      title: Text(title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: color ?? (isSelected ? Colors.blueAccent : Colors.grey.shade400),
            fontSize: 16,
          )),
      onTap: onTap,
      tileColor: isSelected ? Colors.blueAccent.withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: color.withOpacity(0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.1),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }
}
