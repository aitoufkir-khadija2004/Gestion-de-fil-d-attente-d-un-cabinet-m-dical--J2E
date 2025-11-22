# 🏥 Système de Gestion de File d'Attente pour Clinique Médicale

[![Java](https://img.shields.io/badge/Java-17-orange.svg)](https://www.oracle.com/java/)
[![JEE](https://img.shields.io/badge/JEE-8-blue.svg)](https://www.oracle.com/java/technologies/javaee-8-sdk-downloads.html)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue.svg)](https://www.mysql.com/)
[![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3-purple.svg)](https://getbootstrap.com/)
[![License](https://img.shields.io/badge/License-Academic-green.svg)]()

## 📋 Table des Matières

- [Description](#-description)
- [Fonctionnalités](#-fonctionnalités)
- [Architecture Technique](#-architecture-technique)
- [Technologies Utilisées](#️-technologies-utilisées)
- [Structure du Projet](#-structure-du-projet)
- [Modèle de Base de Données](#️-modèle-de-base-de-données)
- [Installation](#-installation)
- [Configuration](#️-configuration)
- [Utilisation](#-utilisation)
- [Comptes de Test](#-comptes-de-test)
- [Captures d'Écran](#-captures-décran)
- [Résolution de Problèmes](#-résolution-de-problèmes)
- [Auteur](#-auteur)

---

## 📋 Description

**Projet 11** est une application web complète de gestion de file d'attente pour cliniques médicales, développée en architecture JEE (Java Enterprise Edition). Elle permet une gestion digitale moderne des rendez-vous médicaux, des consultations et du flux de patients.

Ce projet a été développé dans le cadre du module **Génie Logiciel** à l'**ENSIAS** (École Nationale Supérieure d'Informatique et d'Analyse des Systèmes), Université Mohammed V, Rabat, Maroc.

### 🎯 Objectifs du Projet

- Digitaliser la gestion des files d'attente en clinique
- Optimiser la prise de rendez-vous médicaux
- Améliorer l'expérience patient avec un système de tickets numériques
- Faciliter la gestion administrative pour le personnel médical
- Fournir des statistiques en temps réel pour les administrateurs

---

## ✨ Fonctionnalités

### 👨‍💼 Espace Administrateur

#### Gestion des Utilisateurs
- ➕ **Création** de comptes (Médecins, Patients, Secrétaires)
- ✏️ **Modification** des profils utilisateurs
- 🔄 **Activation/Désactivation** des comptes
- 🔍 **Consultation** des listes complètes par rôle
- 📊 **Vue détaillée** de chaque utilisateur

#### Gestion des Spécialités
- ➕ **Ajout** de nouvelles spécialités médicales
- ✏️ **Modification** des descriptions
- 🗑️ **Suppression** sécurisée (vérification des dépendances)
- 📋 **Liste complète** avec codes automatiques

#### Tableau de Bord
- 📈 **Statistiques globales** : nombre total d'utilisateurs par rôle
- 📊 **Indicateurs clés** : spécialités disponibles, tickets actifs
- 🔗 **Accès rapide** aux différentes sections de gestion
- 🎨 **Interface intuitive** avec cartes statistiques colorées

### 👨‍⚕️ Espace Médecin

#### Gestion des Disponibilités
- 📅 **Création** de créneaux horaires de consultation
- ⏰ **Définition** des plages horaires (début/fin)
- 📆 **Planification** hebdomadaire/mensuelle
- ✏️ **Modification** des créneaux existants
- 🗑️ **Suppression** des créneaux obsolètes

#### Gestion de la File d'Attente
- 👥 **Visualisation en temps réel** de la file d'attente
- 🎫 **Gestion des tickets** : En attente / En consultation / Terminé
- 🔔 **Notifications** pour les nouveaux patients
- 📊 **Suivi** du nombre de consultations journalières

#### Consultations
- 📝 **Saisie** des diagnostics et traitements
- 💊 **Prescription** médicale
- 📋 **Historique** des consultations par patient
- 📄 **Notes médicales** détaillées

### 👤 Espace Patient

#### Prise de Rendez-vous
- 🎫 **Génération automatique** de tickets numériques
- 👨‍⚕️ **Sélection** du médecin souhaité
- 🏥 **Choix** de la spécialité médicale
- 📅 **Réservation** de créneaux disponibles
- ⏱️ **Estimation** du temps d'attente

#### Suivi Personnel
- 📊 **Visualisation** de la position dans la file
- 🔔 **Notifications** d'avancement
- 📜 **Historique** des consultations précédentes
- 📄 **Accès** aux ordonnances et diagnostics

#### Profil Patient
- 👤 **Gestion** des informations personnelles
- 🩸 **Groupe sanguin** et allergies
- 📞 **Coordonnées** de contact
- 📋 **Dossier médical** numérique

### 👩‍💼 Espace Secrétaire

#### Accueil et Enregistrement
- 🎫 **Génération** de tickets pour patients sans compte
- 📝 **Enregistrement rapide** des patients
- 📋 **Pré-remplissage** des formulaires d'admission
- ☎️ **Support téléphonique** pour les rendez-vous

#### Gestion Administrative
- 📊 **Suivi** de la file d'attente globale
- 📞 **Coordination** entre patients et médecins
- 📅 **Gestion** des rendez-vous urgents
- 📄 **Édition** des documents administratifs

#### Support Patients
- ❓ **Réponses** aux questions courantes
- 🗺️ **Orientation** dans la clinique
- 📋 **Assistance** pour les formulaires
- 📞 **Gestion** des appels entrants

---

## 🏗️ Architecture Technique

### Modèle MVC (Model-View-Controller)
```
┌─────────────────────────────────────────────────────────┐
│                      UTILISATEUR                         │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                    CONTRÔLEURS                           │
│  (Servlets : LoginServlet, AdminServlet, etc.)          │
└────────────┬────────────────────────┬────────────────────┘
             │                        │
             ▼                        ▼
┌─────────────────────┐    ┌─────────────────────────────┐
│      MODÈLES        │    │          VUES               │
│  (Beans : User,     │    │  (JSP : login.jsp,          │
│   Medecin, etc.)    │    │   dashboard.jsp, etc.)      │
└──────────┬──────────┘    └─────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────────┐
│                   COUCHE DAO                             │
│  (UserDAO, SpecialiteDAO, TicketDAO, etc.)              │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│              BASE DE DONNÉES MySQL                       │
│  (Tables : user, specialite, ticket, etc.)              │
└─────────────────────────────────────────────────────────┘
```

### Pattern DAO (Data Access Object)
```java
Interface DAO → Implémentation DAO → Servlet → JSP
    ↓                 ↓                 ↓
  Contrat      Logique Métier     Contrôleur
                    ↓
              Base de données
```

### Flux de Traitement d'une Requête
```
1. Client (Navigateur) → Envoie requête HTTP
2. Servlet (Contrôleur) → Reçoit et analyse la requête
3. DAO → Effectue les opérations sur la base de données
4. Bean (Modèle) → Encapsule les données
5. JSP (Vue) → Génère la page HTML
6. Client → Reçoit la réponse HTTP
```

---

## 🛠️ Technologies Utilisées

### Backend

| Technologie | Version | Utilisation |
|-------------|---------|-------------|
| **Java** | 17 | Langage de programmation principal |
| **JEE (Java Enterprise Edition)** | 8 | Framework d'application web |
| **Servlets** | 4.0 | Contrôleurs HTTP |
| **JSP (JavaServer Pages)** | 2.3 | Pages web dynamiques |
| **JDBC** | - | Accès aux données |
| **Apache Tomcat** | 10.1 | Serveur d'applications |

### Frontend

| Technologie | Version | Utilisation |
|-------------|---------|-------------|
| **HTML5** | - | Structure des pages |
| **CSS3** | - | Styles et mise en page |
| **Bootstrap** | 5.3.2 | Framework UI responsive |
| **Bootstrap Icons** | 1.11.1 | Bibliothèque d'icônes |
| **JavaScript** | ES6+ | Interactivité client |

### Base de Données

| Technologie | Version | Utilisation |
|-------------|---------|-------------|
| **MySQL** | 8.0 | Système de gestion de base de données |
| **MySQL Workbench** | 8.0 | Administration et conception |

### Outils de Développement

| Outil | Utilisation |
|-------|-------------|
| **Eclipse IDE** | Environnement de développement |
| **Git** | Gestion de versions |
| **GitHub** | Hébergement du code source |
| **Maven** (optionnel) | Gestion des dépendances |

---

## 📁 Structure du Projet
```
Projet11/
│
├── src/
│   └── main/
│       └── java/
│           │
│           ├── beans/                      # 📦 Entités Métier (POJOs)
│           │   ├── User.java              # Classe parent pour tous les utilisateurs
│           │   ├── Medecin.java           # Médecin (hérite de User)
│           │   ├── Patient.java           # Patient (hérite de User)
│           │   ├── Secretaire.java        # Secrétaire (hérite de User)
│           │   ├── Specialite.java        # Spécialité médicale
│           │   ├── Ticket.java            # Ticket de file d'attente
│           │   ├── Creneau.java           # Créneau de disponibilité médecin
│           │   └── Consultation.java      # Consultation médicale
│           │
│           ├── dao/                        # 🔌 Interfaces DAO
│           │   ├── UserDAO.java           # Interface pour gestion User
│           │   ├── SpecialiteDAO.java     # Interface pour gestion Specialite
│           │   ├── TicketDAO.java         # Interface pour gestion Ticket
│           │   └── CreneauDAO.java        # Interface pour gestion Creneau
│           │
│           ├── dao/impl/                   # ⚙️ Implémentations DAO
│           │   ├── UserDAOImpl.java       # Implémentation UserDAO
│           │   ├── SpecialiteDAOImpl.java # Implémentation SpecialiteDAO
│           │   ├── TicketDAOImpl.java     # Implémentation TicketDAO
│           │   └── CreneauDAOImpl.java    # Implémentation CreneauDAO
│           │
│           ├── servlets/                   # 🎮 Contrôleurs (Servlets)
│           │   ├── LoginServlet.java      # Authentification
│           │   ├── LogoutServlet.java     # Déconnexion
│           │   ├── AdminServlet.java      # Fonctionnalités Admin
│           │   ├── MedecinServlet.java    # Fonctionnalités Médecin
│           │   ├── PatientServlet.java    # Fonctionnalités Patient
│           │   └── SecretaireServlet.java # Fonctionnalités Secrétaire
│           │
│           └── util/                       # 🔧 Classes Utilitaires
│               └── TestConnectionJDBC.java # Gestion connexion BDD
│
├── webapp/
│   │
│   ├── WEB-INF/
│   │   │
│   │   ├── views/                         # 📄 Pages JSP
│   │   │   │
│   │   │   ├── admin/                     # Pages Admin
│   │   │   │   ├── dashboard.jsp         # Tableau de bord
│   │   │   │   ├── creer-utilisateur.jsp # Création utilisateur
│   │   │   │   ├── medecins.jsp          # Liste médecins
│   │   │   │   ├── patients.jsp          # Liste patients
│   │   │   │   ├── secretaires.jsp       # Liste secrétaires
│   │   │   │   └── specialites.jsp       # Gestion spécialités
│   │   │   │
│   │   │   ├── medecin/                   # Pages Médecin
│   │   │   │   ├── dashboard.jsp         # Tableau de bord médecin
│   │   │   │   ├── creneaux.jsp          # Gestion créneaux
│   │   │   │   ├── file-attente.jsp      # File d'attente
│   │   │   │   └── consultations.jsp     # Historique consultations
│   │   │   │
│   │   │   ├── patient/                   # Pages Patient
│   │   │   │   ├── dashboard.jsp         # Tableau de bord patient
│   │   │   │   ├── prendre-ticket.jsp    # Prise de ticket
│   │   │   │   ├── mes-tickets.jsp       # Mes tickets
│   │   │   │   └── historique.jsp        # Historique consultations
│   │   │   │
│   │   │   ├── secretaire/                # Pages Secrétaire
│   │   │   │   ├── dashboard.jsp         # Tableau de bord secrétaire
│   │   │   │   ├── generer-ticket.jsp    # Générer ticket
│   │   │   │   └── file-attente.jsp      # Vue globale file
│   │   │   │
│   │   │   └── login.jsp                  # Page de connexion
│   │   │
│   │   └── web.xml                        # Configuration web
│   │
│   └── images/                            # 🖼️ Ressources images
│       └── logo1.png                      # Logo de la clinique
│
├── database/
│   └── gestion_file_attente.sql           # 🗄️ Script de création BDD
│
└── README.md                               # 📖 Documentation projet
```

---

## 🗄️ Modèle de Base de Données

### Schéma Relationnel
```sql
┌──────────────────────────────────────────────────────────┐
│                         USER                              │
├──────────────────────────────────────────────────────────┤
│ PK  id                    INT                             │
│     code_user             VARCHAR(50)  UNIQUE             │
│     nom                   VARCHAR(100)                    │
│     prenom                VARCHAR(100)                    │
│     email                 VARCHAR(100) UNIQUE             │
│     password              VARCHAR(255)                    │
│     role                  ENUM('ADMIN','MEDECIN',...)     │
│     telephone             VARCHAR(20)                     │
│ FK  specialite_id         INT         (pour MEDECIN)      │
│     numero_ordre          VARCHAR(50) (pour MEDECIN)      │
│     date_naissance        DATE        (pour PATIENT)      │
│     groupe_sanguin        VARCHAR(5)  (pour PATIENT)      │
│     numero_securite_sociale VARCHAR(50) (pour PATIENT)   │
│     adresse               TEXT        (pour PATIENT)      │
│     service               VARCHAR(100) (pour SECRETAIRE)  │
│     actif                 BOOLEAN     DEFAULT TRUE        │
│     created_at            TIMESTAMP                       │
└──────────────────────────────────────────────────────────┘
                              │
                              │ FK specialite_id
                              ▼
┌──────────────────────────────────────────────────────────┐
│                      SPECIALITE                           │
├──────────────────────────────────────────────────────────┤
│ PK  id                    INT                             │
│     code_specialite       VARCHAR(50)  UNIQUE             │
│     nom                   VARCHAR(100)                    │
│     description           TEXT                            │
│     created_at            TIMESTAMP                       │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│                        CRENEAU                            │
├──────────────────────────────────────────────────────────┤
│ PK  id                    INT                             │
│ FK  medecin_id            INT                             │
│     jour_semaine          VARCHAR(20)                     │
│     heure_debut           TIME                            │
│     heure_fin             TIME                            │
│     date_debut            DATE                            │
│     date_fin              DATE                            │
│     actif                 BOOLEAN                         │
│     created_at            TIMESTAMP                       │
└──────────────────────────────────────────────────────────┘
                              │
                              │ FK medecin_id
                              ▼
                          [USER]

┌──────────────────────────────────────────────────────────┐
│                         TICKET                            │
├──────────────────────────────────────────────────────────┤
│ PK  id                    INT                             │
│     numero_ticket         VARCHAR(50)  UNIQUE             │
│ FK  patient_id            INT                             │
│ FK  medecin_id            INT                             │
│     statut                ENUM('EN_ATTENTE',...)          │
│     date_creation         TIMESTAMP                       │
│     heure_arrivee         TIME                            │
│     position_file         INT                             │
└──────────────────────────────────────────────────────────┘
                              │
                              │ FK patient_id, medecin_id
                              ▼
                          [USER]

┌──────────────────────────────────────────────────────────┐
│                     CONSULTATION                          │
├──────────────────────────────────────────────────────────┤
│ PK  id                    INT                             │
│ FK  ticket_id             INT         UNIQUE              │
│ FK  medecin_id            INT                             │
│ FK  patient_id            INT                             │
│     date_consultation     DATE                            │
│     heure_debut           TIME                            │
│     heure_fin             TIME                            │
│     diagnostic            TEXT                            │
│     traitement            TEXT                            │
│     notes                 TEXT                            │
│     created_at            TIMESTAMP                       │
└──────────────────────────────────────────────────────────┘
```

### Description des Tables

#### 📋 Table `user`
Stocke tous les utilisateurs du système avec polymorphisme par rôle.

**Champs communs :**
- `id` : Identifiant unique
- `code_user` : Code généré automatiquement (MED-XXXX, PAT-XXXX, etc.)
- `nom`, `prenom` : Identité
- `email`, `password` : Authentification
- `role` : Type d'utilisateur (ADMIN, MEDECIN, PATIENT, SECRETAIRE)
- `telephone` : Contact
- `actif` : État du compte

**Champs spécifiques MEDECIN :**
- `specialite_id` : Référence vers la spécialité
- `numero_ordre` : Numéro d'ordre des médecins

**Champs spécifiques PATIENT :**
- `date_naissance` : Date de naissance
- `groupe_sanguin` : Groupe sanguin (A+, O-, etc.)
- `numero_securite_sociale` : N° sécurité sociale
- `adresse` : Adresse complète

**Champs spécifiques SECRETAIRE :**
- `service` : Service d'affectation

#### 🏥 Table `specialite`
Liste des spécialités médicales disponibles.

**Exemples :**
- Cardiologie
- Pédiatrie
- Neurologie
- Dermatologie

#### 📅 Table `creneau`
Créneaux de disponibilité des médecins.

**Caractéristiques :**
- Plages horaires définies (heure_debut → heure_fin)
- Jours de la semaine
- Période de validité (date_debut → date_fin)
- État (actif/inactif)

#### 🎫 Table `ticket`
Tickets de file d'attente générés pour les patients.

**Statuts possibles :**
- `EN_ATTENTE` : Patient en attente
- `EN_CONSULTATION` : Consultation en cours
- `TERMINE` : Consultation terminée
- `ANNULE` : Ticket annulé

**Numérotation :** Format TKT-YYYYMMDD-XXXX

#### 💊 Table `consultation`
Enregistrements des consultations médicales.

**Contenu :**
- Diagnostic médical
- Traitement prescrit
- Notes complémentaires
- Durée de la consultation

### Relations Entre Tables
```
user (MEDECIN) ──1:N── specialite
user (MEDECIN) ──1:N── creneau
user (PATIENT) ──1:N── ticket
user (MEDECIN) ──1:N── ticket
ticket ──1:1── consultation
```

---

## 🚀 Installation

### Prérequis Système

#### Logiciels Requis

| Logiciel | Version Minimale | Téléchargement |
|----------|------------------|----------------|
| **Java JDK** | 17 | [Oracle JDK](https://www.oracle.com/java/technologies/downloads/) |
| **Apache Tomcat** | 10.1 | [Tomcat Downloads](https://tomcat.apache.org/download-10.cgi) |
| **MySQL** | 8.0 | [MySQL Downloads](https://dev.mysql.com/downloads/mysql/) |
| **Eclipse IDE** | 2023-12 ou supérieur | [Eclipse IDE](https://www.eclipse.org/downloads/) |
| **Git** | 2.0+ | [Git Downloads](https://git-scm.com/downloads) |

#### Configuration Matérielle Recommandée
- **RAM** : 8 GB minimum
- **Espace disque** : 2 GB disponible
- **Processeur** : Intel Core i5 ou équivalent

### Étapes d'Installation Détaillées

#### 1️⃣ Cloner le Projet
```bash
# Via HTTPS
git clone https://github.com/votre-username/Projet11-Gestion-Clinique.git

# Via SSH
git clone git@github.com:votre-username/Projet11-Gestion-Clinique.git

# Se déplacer dans le répertoire
cd Projet11-Gestion-Clinique
```

#### 2️⃣ Configuration de MySQL

**Étape 2.1 : Démarrer MySQL**
```bash
# Windows
net start MySQL80

# macOS (Homebrew)
brew services start mysql

# Linux (systemd)
sudo systemctl start mysql
```

**Étape 2.2 : Créer la Base de Données**
```bash
# Se connecter à MySQL
mysql -u root -p

# Entrer le mot de passe root
```
```sql
-- Créer la base avec encodage UTF-8
CREATE DATABASE gestion_clinique 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Utiliser la base
USE gestion_clinique;

-- Importer le script SQL (depuis MySQL)
SOURCE /chemin/vers/database/gestion_file_attente.sql;

-- OU via ligne de commande (hors MySQL)
mysql -u root -p gestion_clinique < database/gestion_file_attente.sql
```

**Étape 2.3 : Vérifier l'Import**
```sql
-- Lister les tables
SHOW TABLES;

-- Vérifier la structure
DESCRIBE user;
DESCRIBE specialite;
DESCRIBE ticket;
DESCRIBE creneau;
DESCRIBE consultation;

-- Compter les enregistrements
SELECT COUNT(*) FROM user;
SELECT COUNT(*) FROM specialite;
```

**Étape 2.4 : Créer un Utilisateur Dédié (Optionnel mais Recommandé)**
```sql
-- Créer un utilisateur pour l'application
CREATE USER 'clinique_user'@'localhost' IDENTIFIED BY 'MotDePasseSecurise123!';

-- Donner les permissions
GRANT ALL PRIVILEGES ON gestion_clinique.* TO 'clinique_user'@'localhost';

-- Appliquer les changements
FLUSH PRIVILEGES;
```

#### 3️⃣ Configuration du Projet Java

**Étape 3.1 : Modifier la Connexion JDBC**

Ouvrir `src/util/TestConnectionJDBC.java` et modifier :
```java
package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class TestConnectionJDBC {
    
    // ⚠️ MODIFIER CES VALEURS SELON VOTRE CONFIGURATION
    private static final String URL = "jdbc:mysql://localhost:3306/gestion_clinique?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC";
    private static final String USER = "root";              // Votre utilisateur MySQL
    private static final String PASSWORD = "votre_password"; // Votre mot de passe MySQL
    
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ Driver MySQL chargé avec succès");
        } catch (ClassNotFoundException e) {
            System.err.println("❌ ERREUR : Driver MySQL non trouvé");
            e.printStackTrace();
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
    
    // Méthode de test
    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("✅ Connexion réussie à la base de données !");
                System.out.println("📊 Database: " + conn.getCatalog());
            }
        } catch (SQLException e) {
            System.err.println("❌ ERREUR de connexion : " + e.getMessage());
            e.printStackTrace();
        }
    }
}
```

**Étape 3.2 : Tester la Connexion**
```bash
# Compiler et exécuter le test
javac src/util/TestConnectionJDBC.java
java -cp src:mysql-connector-java.jar util.TestConnectionJDBC
```

Vous devriez voir :
```
✅ Driver MySQL chargé avec succès
✅ Connexion réussie à la base de données !
📊 Database: gestion_clinique
```

#### 4️⃣ Import dans Eclipse IDE

**Étape 4.1 : Ouvrir Eclipse**

1. Lancer Eclipse IDE
2. Sélectionner un workspace
3. Fermer l'écran de bienvenue

**Étape 4.2 : Importer le Projet**
```
File → Import → General → Existing Projects into Workspace
→ Select root directory : [Parcourir vers Projet11]
→ Cocher le projet
→ Finish
```

**Étape 4.3 : Configurer le Build Path**
```
Clic droit sur le projet → Build Path → Configure Build Path
→ Onglet "Libraries"
→ Add External JARs
→ Ajouter : mysql-connector-java-8.x.x.jar
→ Apply and Close
```

**Étape 4.4 : Configurer Tomcat dans Eclipse**
```
Window → Preferences → Server → Runtime Environments
→ Add → Apache Tomcat v10.1
→ Browse : [Chemin vers Tomcat]
→ Finish → Apply and Close
```

#### 5️⃣ Déploiement sur Tomcat

**Méthode 1 : Via Eclipse**
```
1. Clic droit sur le projet
2. Run As → Run on Server
3. Choisir "Tomcat v10.1 Server"
4. Next → Add > (ajouter le projet) → Finish
```

**Méthode 2 : Génération WAR et Déploiement Manuel**
```bash
# Générer le fichier WAR
jar -cvf Projet11.war -C webapp/ .

# Copier dans Tomcat
cp Projet11.war /chemin/vers/tomcat/webapps/

# Démarrer Tomcat
cd /chemin/vers/tomcat/bin
./startup.sh      # Linux/Mac
startup.bat       # Windows
```

#### 6️⃣ Vérification de l'Installation

**Test de Connexion BDD**
```bash
# Accéder au test de connexion
http://localhost:8080/Projet11/test-connexion
```

**Accès à l'Application**
```bash
# Page de connexion
http://localhost:8080/Projet11/login
```

**Vérification des Logs**
```bash
# Consulter les logs Tomcat
tail -f /chemin/vers/tomcat/logs/catalina.out    # Linux/Mac
type tomcat\logs\catalina.out                     # Windows
```

Vous devriez voir :
```
INFO: Démarrage du service [Catalina]
INFO: Déploiement de l'application web [/Projet11]
✅ AdminServlet initialisé
✅ Driver MySQL chargé avec succès
```

---

## ⚙️ Configuration

### Configuration de l'Encodage UTF-8

**web.xml**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns="http://xmlns.jcp.org/xml/ns/javaee"
    xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee 
    http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
    version="4.0">
    
    <display-name>Gestion Clinique - Projet 11</display-name>
    
    <!-- Filtre d'encodage UTF-8 -->
    <filter>
        <filter-name>encodingFilter</filter-name>
        <filter-class>org.apache.catalina.filters.SetCharacterEncodingFilter</filter-class>
        <init-param>
            <param-name>encoding</param-name>
            <param-value>UTF-8</param-value>
        </init-param>
        <init-param>
            <param-name>ignore</param-name>
            <param-value>false</param-value>
        </init-param>
    </filter>
    
    <filter-mapping>
        <filter-name>encodingFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
    
    <!-- Page de bienvenue -->
    <welcome-file-list>
        <welcome-file>login</welcome-file>
    </welcome-file-list>
    
    <!-- Configuration session -->
    <session-config>
        <session-timeout>30</session-timeout>
    </session-config>
    
</web-app>
```

### Configuration MySQL pour UTF-8
```sql
-- Vérifier l'encodage actuel
SHOW VARIABLES LIKE 'character%';

-- Modifier l'encodage de la base
ALTER DATABASE gestion_clinique 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Modifier l'encodage des tables
ALTER TABLE user CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE specialite CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE ticket CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE creneau CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE consultation CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### Variables d'Environnement (Optionnel)

Pour une meilleure sécurité, utiliser des variables d'environnement :

**Linux/Mac (.bashrc ou .zshrc)**
```bash
export DB_URL="jdbc:mysql://localhost:3306/gestion_clinique"
export DB_USER="root"
export DB_PASSWORD="votre_password"
```

**Windows (Variables Système)**
```
Panneau de configuration → Système → Paramètres système avancés
→ Variables d'environnement → Nouvelles variables système
```

**Utilisation dans le code Java**
```java
private static final String URL = System.getenv("DB_URL");
private static final String USER = System.getenv("DB_USER");
private static final String PASSWORD = System.getenv("DB_PASSWORD");
```

---

## 💻 Utilisation

### Démarrage de l'Application

#### 1. Démarrer MySQL
```bash
# Vérifier le statut
sudo systemctl status mysql

# Démarrer si nécessaire
sudo systemctl start mysql
```

#### 2. Démarrer Tomcat
```bash
# Via Eclipse : Run on Server

# Via ligne de commande
cd /chemin/vers/tomcat/bin
./startup.sh      # Linux/Mac
startup.bat       # Windows
```

#### 3. Accéder à l'Application
```
http://localhost:8080/Projet11/login
```

### Workflows Principaux

#### 🔐 Connexion
```
1. Accéder à http://localhost:8080/Projet11/login
2. Entrer email et mot de passe
3. Cliquer sur "Se connecter"
4. Redirection selon le rôle :
   - ADMIN      → /admin/dashboard
   - MEDECIN    → /medecin/dashboard
   - PATIENT    → /patient/dashboard
   - SECRETAIRE → /secretaire/dashboard
```

#### 👨‍💼 Workflow Administrateur

**Créer un Médecin**
```
1. Dashboard Admin → "Créer un Utilisateur"
2. Sélectionner "Médecin"
3. Remplir le formulaire :
   - Nom, Prénom
   - Email (unique)
   - Téléphone
   - Spécialité (liste déroulante)
   - N° d'ordre
4. Soumettre → Compte créé avec code MED-XXXX
5. Mot de passe par défaut : "medecin123"
```

**Créer une Spécialité**
```
1. Dashboard Admin → "Spécialités"
2. Remplir le formulaire en haut :
   - Nom de la spécialité
   - Description (optionnel)
3. Cliquer sur "Créer la Spécialité"
4. Code généré automatiquement : SPEC-XXX
```

**Modifier un Utilisateur**
```
1. Aller dans la liste (Médecins/Patients/Secrétaires)
2. Cliquer sur le bouton jaune "Modifier" (icône crayon)
3. Modal s'ouvre avec les données actuelles
4. Modifier les champs souhaités
5. Cliquer sur "Enregistrer"
```

**Désactiver un Compte**
```
1. Liste des utilisateurs
2. Cliquer sur le bouton gris "Désactiver" (icône X)
3. Confirmer l'action
4. L'utilisateur ne peut plus se connecter
5. La ligne devient grisée dans la liste
```

#### 👨‍⚕️ Workflow Médecin

**Créer un Créneau de Disponibilité**
```
1. Dashboard Médecin → "Mes Créneaux"
2. Cliquer sur "Nouveau Créneau"
3. Définir :
   - Jour de la semaine
   - Heure de début (ex: 09:00)
   - Heure de fin (ex: 12:00)
   - Date de début de validité
   - Date de fin de validité
4. Soumettre → Créneau créé
```

**Gérer la File d'Attente**
```
1. Dashboard Médecin → "File d'Attente"
2. Voir les patients en attente
3. Appeler le prochain patient (clic sur "Appeler")
4. Statut passe à "EN_CONSULTATION"
5. Après consultation :
   - Cliquer sur "Terminer"
   - Saisir diagnostic et traitement
   - Valider → Consultation enregistrée
```

#### 👤 Workflow Patient

**Prendre un Ticket**
```
1. Dashboard Patient → "Prendre un Ticket"
2. Sélectionner :
   - Spécialité médicale (liste déroulante)
   - Médecin disponible (selon spécialité)
3. Cliquer sur "Générer le Ticket"
4. Ticket créé avec :
   - Numéro unique : TKT-20250120-0001
   - Position dans la file
   - Temps d'attente estimé
```

**Consulter Mes Tickets**
```
1. Dashboard Patient → "Mes Tickets"
2. Voir tous les tickets :
   - EN_ATTENTE : En file d'attente
   - EN_CONSULTATION : Consultation en cours
   - TERMINE : Consultation terminée
3. Détails : Position, temps d'attente, médecin
```

#### 👩‍💼 Workflow Secrétaire

**Générer un Ticket pour un Patient**
```
1. Dashboard Secrétaire → "Générer Ticket"
2. Rechercher ou créer le patient
3. Sélectionner médecin et spécialité
4. Générer le ticket
5. Imprimer (optionnel)
```

---

## 👥 Comptes de Test

### Identifiants par Défaut

| Rôle | Email | Mot de passe | Code Utilisateur |
|------|-------|--------------|------------------|
| **Administrateur** | admin@clinic.ma | admin123 | ADM-0001 |
| **Médecin Cardiologue** | medecin1@clinic.ma | medecin123 | MED-0001 |
| **Médecin Pédiatre** | medecin2@clinic.ma | medecin123 | MED-0002 |
| **Patient 1** | patient1@clinic.ma | patient123 | PAT-0001 |
| **Patient 2** | patient2@clinic.ma | patient123 | PAT-0002 |
| **Secrétaire** | secretaire@clinic.ma | secretaire123 | SEC-0001 |

### Données de Test Disponibles

**Spécialités Préchargées**
- Médecine Générale (SPEC-000)
- Neurologie (SPEC-001)
- Cardiologie (SPEC-002)
- Pédiatrie (SPEC-003)
- Orthopédie (SPEC-004)
- Dermatologie (SPEC-005)

**Médecins de Test**
- Dr. Alami Hassan - Cardiologie
- Dr. Benali Ahmed - Pédiatrie
- Dr. El Alaoui Fatima - Neurologie

**Patients de Test**
- Mohammed Tazi - Groupe O+
- Fatima Chraibi - Groupe A+
- Ahmed Idrissi - Groupe B+

---

## 📸 Captures d'Écran

### Page de Connexion
```
┌─────────────────────────────────────────────────────┐
│  🏥 CLINIQUE SIHHATI - Système de Gestion          │
├─────────────────────────────────────────────────────┤
│                                                     │
│         [Logo de la Clinique]                       │
│                                                     │
│         📧 Email: [__________________]              │
│         🔒 Mot de passe: [__________]               │
│                                                     │
│              [Se Connecter]                         │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Dashboard Administrateur
```
┌─────────────────────────────────────────────────────┐
│  👨‍💼 Tableau de Bord - Administrateur              │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐          │
│  │ 👨‍⚕️ 15    │  │ 👤 150   │  │ 👩‍💼 5    │          │
│  │ Médecins │  │ Patients │  │ Secrét.  │          │
│  └──────────┘  └──────────┘  └──────────┘          │
│                                                     │
│  Accès Rapide:                                      │
│  [👨‍⚕️ Médecins] [👤 Patients] [🏥 Spécialités]    │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Liste des Médecins
```
┌─────────────────────────────────────────────────────┐
│  👨‍⚕️ Liste des Médecins            [+ Nouveau]    │
├─────────────────────────────────────────────────────┤
│ Code    │ Nom      │ Email         │ Spécialité    │
├─────────┼──────────┼───────────────┼───────────────┤
│ MED-001 │ Alami H. │ h.alami@...   │ Cardiologie   │
│ MED-002 │ Benali A.│ a.benali@...  │ Pédiatrie     │
│         │          │               │ [✏️] [❌]      │
└─────────────────────────────────────────────────────┘
```

### Prise de Ticket Patient
```
┌─────────────────────────────────────────────────────┐
│  🎫 Prendre un Ticket                               │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Spécialité: [Cardiologie        ▼]                │
│  Médecin:    [Dr. Alami Hassan   ▼]                │
│                                                     │
│  Créneaux disponibles:                              │
│  • Lundi 09:00 - 12:00                              │
│  • Mercredi 14:00 - 17:00                           │
│                                                     │
│            [Générer le Ticket]                      │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## 🐛 Résolution de Problèmes

### Problèmes de Connexion Base de Données

#### ❌ Erreur : "Communications link failure"

**Cause** : MySQL n'est pas démarré ou inaccessible

**Solution** :
```bash
# Vérifier le statut MySQL
sudo systemctl status mysql

# Démarrer MySQL
sudo systemctl start mysql

# Vérifier le port d'écoute
netstat -an | grep 3306
```

#### ❌ Erreur : "Access denied for user"

**Cause** : Identifiants MySQL incorrects

**Solution** :
```sql
-- Réinitialiser le mot de passe root
ALTER USER 'root'@'localhost' IDENTIFIED BY 'nouveau_password';
FLUSH PRIVILEGES;
```

Puis modifier `TestConnectionJDBC.java` avec le nouveau mot de passe.

#### ❌ Erreur : "Unknown database 'gestion_clinique'"

**Cause** : La base de données n'existe pas

**Solution** :
```sql
-- Créer la base
CREATE DATABASE gestion_clinique CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Importer le script
USE gestion_clinique;
SOURCE /chemin/vers/gestion_file_attente.sql;
```

### Problèmes d'Encodage UTF-8

#### ❌ Caractères corrompus (Ã©, Ã , etc.)

**Cause** : Encodage mal configuré

**Solution 1 - Base de données** :
```sql
-- Vérifier l'encodage actuel
SHOW VARIABLES LIKE 'character%';

-- Modifier l'encodage de la table
ALTER TABLE specialite CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

**Solution 2 - Connexion JDBC** :
```java
// Ajouter dans l'URL de connexion
private static final String URL = "jdbc:mysql://localhost:3306/gestion_clinique?useUnicode=true&characterEncoding=UTF-8";
```

**Solution 3 - Avant chaque requête SQL** :
```java
try (Statement stmt = conn.createStatement()) {
    stmt.execute("SET NAMES 'utf8mb4'");
}
```

**Solution 4 - Corriger les données existantes** :
```sql
-- Supprimer les données corrompues
DELETE FROM specialite WHERE description LIKE '%Ã%';

-- Réinsérer avec le bon encodage
SET NAMES 'utf8mb4';
INSERT INTO specialite (code_specialite, nom, description) VALUES 
('SPEC-001', 'Neurologie', 'Spécialité dans le diagnostic et le traitement des maladies du cerveau');
```

### Problèmes Tomcat

#### ❌ Erreur : "Port 8080 already in use"

**Cause** : Un autre processus utilise le port 8080

**Solution** :
```bash
# Trouver le processus
lsof -i :8080    # Linux/Mac
netstat -ano | findstr :8080    # Windows

# Tuer le processus
kill -9 <PID>    # Linux/Mac
taskkill /PID <PID> /F    # Windows

# Ou changer le port Tomcat
# Éditer tomcat/conf/server.xml
<Connector port="8081" protocol="HTTP/1.1" />
```

#### ❌ Erreur : "HTTP Status 404 - Not Found"

**Cause** : JSP introuvable ou mal référencé

**Solution** :
1. Vérifier que les JSP sont dans `/WEB-INF/views/`
2. Vérifier le chemin dans le servlet :
```java
request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
```
3. Vérifier les logs Tomcat pour le chemin exact demandé

#### ❌ Erreur : "java.lang.ClassNotFoundException: com.mysql.cj.jdbc.Driver"

**Cause** : Driver MySQL manquant

**Solution** :
1. Télécharger `mysql-connector-java-8.x.x.jar`
2. Copier dans `/WEB-INF/lib/` du projet
3. Ou ajouter au Build Path dans Eclipse

### Problèmes de Session

#### ❌ Déconnexion automatique après quelques minutes

**Cause** : Timeout de session trop court

**Solution** :
```xml
<!-- Dans web.xml -->
<session-config>
    <session-timeout>60</session-timeout>  <!-- 60 minutes -->
</session-config>
```

#### ❌ Perte de session après redirection

**Cause** : Session non propagée

**Solution** :
```java
// Vérifier que la session est bien récupérée
HttpSession session = request.getSession();  // true par défaut
// OU
HttpSession session = request.getSession(false);  // null si pas de session

// Toujours vérifier avant utilisation
if (session != null) {
    User user = (User) session.getAttribute("user");
}
```

### Problèmes d'Affichage JSP

#### ❌ Liste vide alors que la base contient des données

**Cause** : Attribut non passé au JSP

**Solution - Dans le Servlet** :
```java
List<Medecin> medecins = userDAO.getAllMedecins();
List<Specialite> specialites = specialiteDAO.getAllSpecialites();

// ✅ Ne pas oublier ces lignes
request.setAttribute("medecins", medecins);
request.setAttribute("specialites", specialites);

request.getRequestDispatcher("/WEB-INF/views/admin/medecins.jsp").forward(request, response);
```

**Solution - Dans le JSP** :
```jsp
<%
    // Vérifier que l'attribut existe
    @SuppressWarnings("unchecked")
    List<Medecin> medecins = (List<Medecin>) request.getAttribute("medecins");
    
    // Debug
    System.out.println("Nombre de médecins : " + (medecins != null ? medecins.size() : "NULL"));
%>
```

#### ❌ Modal ne s'affiche pas

**Cause** : Bootstrap JS non chargé ou ID dupliqué

**Solution** :
```jsp
<!-- Vérifier que Bootstrap JS est en bas de page -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Vérifier que chaque modal a un ID unique -->
<div class="modal" id="modalModifier<%= medecin.getId() %>">
```

### Problèmes de Performance

#### ❌ Application lente au démarrage

**Cause** : Trop de requêtes ou connexions non fermées

**Solution** :
```java
// Toujours utiliser try-with-resources
try (Connection conn = TestConnectionJDBC.getConnection();
     PreparedStatement ps = conn.prepareStatement(sql);
     ResultSet rs = ps.executeQuery()) {
    // Traitement
} // Fermeture automatique
```

#### ❌ Fuite mémoire

**Cause** : Objets non libérés

**Solution** :
- Fermer toutes les connexions
- Utiliser un pool de connexions (HikariCP, C3P0)
- Surveiller avec VisualVM ou JConsole

### Logs et Debugging

#### Activer les logs détaillés

**MySQL Query Log** :
```sql
-- Activer le log des requêtes
SET GLOBAL general_log = 'ON';
SET GLOBAL log_output = 'TABLE';

-- Consulter les requêtes
SELECT * FROM mysql.general_log ORDER BY event_time DESC LIMIT 20;
```

**Tomcat Logs** :
```bash
# Suivre les logs en temps réel
tail -f /chemin/vers/tomcat/logs/catalina.out

# Rechercher une erreur spécifique
grep -i "error" /chemin/vers/tomcat/logs/catalina.out
```

**Ajouter des logs dans le code** :
```java
// Dans les Servlets
System.out.println("🔍 DEBUG: Nombre de médecins = " + medecins.size());
System.err.println("❌ ERREUR: " + e.getMessage());

// Dans les DAO
System.out.println("✅ Spécialité créée : " + specialite.getNom());
```

---

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour contribuer à ce projet :

### Processus de Contribution

1. **Fork** le projet
2. **Clone** votre fork
```bash
git clone https://github.com/votre-username/Projet11-Gestion-Clinique.git
```

3. **Créer une branche** pour votre feature
```bash
git checkout -b feature/NouvelleFeature
```

4. **Committer** vos changements
```bash
git add .
git commit -m "Ajout de NouvelleFeature"
```

5. **Push** vers votre fork
```bash
git push origin feature/NouvelleFeature
```

6. Ouvrir une **Pull Request** sur GitHub

### Standards de Code

- ✅ Utiliser des noms de variables explicites en français
- ✅ Commenter le code complexe
- ✅ Respecter l'architecture MVC
- ✅ Ajouter des logs de debug
- ✅ Tester avant de soumettre
- ✅ Suivre les conventions Java

### Exemples de Contributions Bienvenues

- 🐛 Corrections de bugs
- ✨ Nouvelles fonctionnalités
- 📚 Amélioration de la documentation
- 🎨 Améliorations de l'UI
- 🔒 Renforcement de la sécurité
- ⚡ Optimisations de performance

---

## 📝 Licence

Ce projet est développé dans un cadre **académique** à l'**ENSIAS** (École Nationale Supérieure d'Informatique et d'Analyse des Systèmes).

### Utilisation Académique

- ✅ Autorisé pour l'apprentissage et l'éducation
- ✅ Autorisé pour des projets scolaires/universitaires
- ✅ Autorisé pour la recherche académique

### Restrictions

- ❌ Usage commercial sans autorisation
- ❌ Revente du code source
- ❌ Suppression des attributions

### Crédits Obligatoires

Si vous utilisez ce projet, merci de citer :
```
Projet 11 - Système de Gestion de Clinique
Développé par Khadija
ENSIAS - Université Mohammed V, Rabat
Module : Génie Logiciel
Année : 2024-2025
```

---

## 👨‍💻 Auteur

### Informations

**Nom** : Khadija  
**Formation** : Data et Software Engineering  
**École** : ENSIAS (École Nationale Supérieure d'Informatique et d'Analyse des Systèmes)  
**Université** : Mohammed V - Rabat, Maroc  
**Module** : Génie Logiciel  
**Année Académique** : 2024-2025  

### Compétences Développées

- ✅ Architecture JEE (Servlets, JSP)
- ✅ Modèle MVC
- ✅ Pattern DAO
- ✅ Gestion de base de données MySQL
- ✅ Interface utilisateur responsive (Bootstrap)
- ✅ Gestion de projet et documentation

---

## 🙏 Remerciements

### Institutions

- 🎓 **ENSIAS** - École Nationale Supérieure d'Informatique et d'Analyse des Systèmes
- 🏛️ **Université Mohammed V** - Rabat, Maroc
- 👨‍🏫 **Professeurs du module Génie Logiciel** - Pour leur encadrement et expertise

### Technologies Open Source

- ☕ **Oracle Java** - Pour la plateforme Java
- 🐬 **MySQL** - Pour le système de gestion de base de données
- 🐱 **Apache Tomcat** - Pour le serveur d'applications
- 🎨 **Bootstrap Team** - Pour le framework UI
- 🎯 **Bootstrap Icons** - Pour la bibliothèque d'icônes

### Communauté

- 💻 **Stack Overflow** - Pour les solutions techniques
- 📚 **Baeldung** - Pour les tutoriels Java/JEE
- 🌐 **W3Schools** - Pour les références web

---

## 📞 Contact et Support

### Signalement de Bugs

Pour signaler un bug, veuillez ouvrir une **Issue** sur GitHub avec :
- 📝 Description détaillée du bug
- 🔄 Étapes pour reproduire
- ✅ Comportement attendu
- ❌ Comportement actuel
- 📸 Captures d'écran (si applicable)
- 💻 Environnement (OS, Java version, etc.)

### Questions et Suggestions

- 💬 **GitHub Issues** : Pour les questions techniques
- 📧 **Email** : Pour les demandes privées
- 🌟 **Discussions** : Pour les idées d'amélioration

---

## 🎯 Roadmap Future

### Version 2.0 (Planifiée)

- [ ] 📧 Notifications par email
- [ ] 📱 Application mobile (Android/iOS)
- [ ] 📊 Rapports et statistiques avancés
- [ ] 🔐 Authentification à deux facteurs (2FA)
- [ ] 💬 Messagerie interne médecin-patient
- [ ] 📅 Synchronisation avec calendrier Google
- [ ] 🖨️ Impression de tickets et ordonnances
- [ ] 🌐 Support multilingue (FR/AR/EN)
- [ ] 💳 Paiement en ligne
- [ ] 🤖 Chatbot pour assistance patients

### Améliorations Techniques

- [ ] Migration vers Spring Boot
- [ ] API RESTful
- [ ] Tests unitaires (JUnit)
- [ ] Tests d'intégration
- [ ] CI/CD avec Jenkins/GitHub Actions
- [ ] Containerisation (Docker)
- [ ] Déploiement cloud (AWS/Azure)

---

## 📚 Ressources Supplémentaires

### Documentation Officielle

- [Java SE Documentation](https://docs.oracle.com/en/java/)
- [Java EE Tutorial](https://javaee.github.io/tutorial/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Apache Tomcat Documentation](https://tomcat.apache.org/tomcat-10.1-doc/)
- [Bootstrap Documentation](https://getbootstrap.com/docs/)

### Tutoriels Recommandés

- [Baeldung - JEE Tutorials](https://www.baeldung.com/java-enterprise)
- [Oracle Java Tutorials](https://docs.oracle.com/javase/tutorial/)
- [W3Schools - Web Development](https://www.w3schools.com/)

### Outils Utiles

- [MySQL Workbench](https://www.mysql.com/products/workbench/) - Administration BDD
- [Postman](https://www.postman.com/) - Tests API
- [DBeaver](https://dbeaver.io/) - Client SQL universel
- [VisualVM](https://visualvm.github.io/) - Monitoring Java

---

## 📊 Statistiques du Projet
```
📦 Lignes de Code     : ~8,000
📁 Fichiers Java      : 25+
📄 Fichiers JSP       : 20+
🗄️ Tables BDD         : 5
⏱️ Durée Développement: 3 mois
👥 Contributeurs      : 1 (Khadija)
```

---

## 🏆 Badges

![Java](https://img.shields.io/badge/Java-17-orange)
![JEE](https://img.shields.io/badge/JEE-8-blue)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3-purple)
![License](https://img.shields.io/badge/License-Academic-green)
![Status](https://img.shields.io/badge/Status-Active-success)
![Maintenance](https://img.shields.io/badge/Maintained-Yes-brightgreen)

---

## ⭐ Star History

Si ce projet vous a aidé, n'hésitez pas à lui donner une **étoile** ⭐ sur GitHub !
```
⭐ Star ce projet → Encourager le développement → Améliorer la qualité
```

---

<div align="center">

### 💙 Merci d'avoir consulté ce projet !

**Fait avec 💻 et ☕ par Khadija**  
**ENSIAS - Université Mohammed V**  
**2024-2025**

---

[⬆ Retour en haut](#-système-de-gestion-de-file-dattente-pour-clinique-médicale)

</div>
