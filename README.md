#  Decoration Agency App

Une application mobile Flutter pour la **gestion d'une agence de décoration**, intégrant :
- Authentification Firebase (email/mot de passe)
- Gestion des employés avec suivi de présence et rémunération
- Gestion des équipements logistiques liés aux événements
- Suivi des finances (recettes, dépenses, solde automatique)
- Génération de **rapports PDF** pour les différentes sections

---

 Fonctionnalités principales

 Authentification
- Connexion via Firebase (email / mot de passe)
- Inscription de nouveaux utilisateurs
- Déconnexion sécurisée

 Gestion des employés
- Ajouter / modifier / supprimer des employés
- Marquer la présence avec date automatique
- Saisir la rémunération journalière
- Calcul automatique du total à payer
- Génération de **rapports PDF mensuels**

 Gestion des équipements (logistique)
- Ajouter / modifier / supprimer les équipements
- Suivi des stocks (quantité disponible)
- Associer un équipement à un événement (type : mariage, conférence…)
- Filtres par événement ou type
- Export PDF

  Finances
- Saisir recettes et dépenses
- Catégoriser les dépenses (ex: achat matériel, paiement employés…)
- Calcul automatique du solde
- Filtres par période
- Visualisation par **graphique**
- Export PDF mensuel

 Rapports
- Génération de fichiers PDF :
  - Présences et salaires
  - Logistique (équipements)
  - Financier (recettes, dépenses, solde)


---

 ⚙️ Installation

 1. Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Un compte [Firebase](https://console.firebase.google.com/)
- Un éditeur (VSCode, Android Studio)

2. Cloner le projet

```bash
git clone https://github.com/Yann1105/Application_sublimer.git
cd application_sublimer

# Installer les dépendances

flutter pub get
flutter run

#Dépendances clés
firebase_core: ^latest
firebase_auth: ^latest
cloud_firestore: ^latest
pdf: ^latest
printing: ^latest
charts_flutter: ^latest

#Contributeurs

GANDEMA Rafissatou - Développeuse Flutter
Suivie OUEDRAOGO Yann Boris - Développeur Full stack



