-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : ven. 21 nov. 2025 à 01:03
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `gestion_file_attente`
--

-- --------------------------------------------------------

--
-- Structure de la table `consultation`
--

CREATE TABLE `consultation` (
  `id` int(11) NOT NULL,
  `code_consultation` varchar(30) NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `medecin_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `date_consultation` timestamp NOT NULL DEFAULT current_timestamp(),
  `symptomes` text DEFAULT NULL,
  `diagnostic` text DEFAULT NULL,
  `prescription` text DEFAULT NULL,
  `notes_medicales` text DEFAULT NULL,
  `duree_consultation` int(11) DEFAULT 15,
  `statut` enum('en_cours','terminee') DEFAULT 'en_cours'
) ;

--
-- Déchargement des données de la table `consultation`
--

INSERT INTO `consultation` (`id`, `code_consultation`, `ticket_id`, `medecin_id`, `patient_id`, `date_consultation`, `symptomes`, `diagnostic`, `prescription`, `notes_medicales`, `duree_consultation`, `statut`) VALUES
(1, 'CON-20251112-0001', 3, 2, 10, '2025-11-11 22:48:52', 'Douleurs thoraciques, essoufflement à l\'effort', 'Arythmie cardiaque légère - Recommandation : ECG de contrôle', 'Bêta-bloquants 25mg, 2 fois par jour pendant 1 mois', NULL, 15, 'terminee'),
(2, 'CON-20251113-0001', 5, 2, 8, '2025-11-13 11:40:32', 'Mal de tête depuis 3 jours', 'test', 'doliprane\r\n', NULL, 15, 'terminee'),
(3, 'CON-20251113-0002', 6, 2, 8, '2025-11-13 11:45:53', 'Mal de tête depuis 3 jours', NULL, NULL, NULL, 15, 'en_cours'),
(4, 'CON-20251114-0001', 7, 2, 8, '2025-11-14 17:38:51', 'Mal de tÃªte depuis 3 jours', 'maladie dans cerveau', 'Doliprane 1000mg, 3 fois par jour pendant 7 jours\r\n', '', 15, 'en_cours'),
(5, 'CON-20251118-0001', 11, 2, 10, '2025-11-17 23:36:01', NULL, NULL, NULL, NULL, 15, 'terminee'),
(6, 'CON-20251118-0002', 12, 2, 14, '2025-11-17 23:37:24', NULL, NULL, NULL, NULL, 15, 'terminee'),
(7, 'CON-20251119-0001', 4, 2, 1, '2025-11-19 11:36:31', NULL, NULL, NULL, NULL, 15, 'en_cours'),
(8, 'CON-20251119-0002', 10, 2, 8, '2025-11-19 22:34:49', NULL, 'stress menant aux crises', 'santilum 100g : une fois par jour pendant 6 mois', NULL, 15, 'en_cours'),
(9, 'CON-20251120-0001', 13, 2, 8, '2025-11-20 18:06:05', NULL, NULL, NULL, NULL, 15, 'en_cours');

-- --------------------------------------------------------

--
-- Structure de la table `creneau`
--

CREATE TABLE `creneau` (
  `id` int(11) NOT NULL,
  `code_creneau` varchar(30) NOT NULL,
  `medecin_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `heure_debut` time NOT NULL,
  `heure_fin` time NOT NULL,
  `capacite` int(11) DEFAULT 10,
  `tickets_pris` int(11) DEFAULT 0,
  `disponible` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ;

--
-- Déchargement des données de la table `creneau`
--

INSERT INTO `creneau` (`id`, `code_creneau`, `medecin_id`, `date`, `heure_debut`, `heure_fin`, `capacite`, `tickets_pris`, `disponible`, `created_at`) VALUES
(1, 'CRE-20251112-0001', 2, '2025-11-11', '09:00:00', '12:00:00', 10, 3, 1, '2025-11-11 22:48:52'),
(2, 'CRE-20251112-0002', 3, '2025-11-11', '09:00:00', '13:00:00', 12, 1, 1, '2025-11-11 22:48:52'),
(3, 'CRE-20251112-0003', 4, '2025-11-11', '14:00:00', '18:00:00', 8, 0, 1, '2025-11-11 22:48:52'),
(4, 'CRE-20251113-0001', 2, '2025-11-12', '09:00:00', '12:00:00', 10, 0, 1, '2025-11-11 22:48:52'),
(5, 'CRE-20251113-0002', 3, '2025-11-12', '14:00:00', '17:00:00', 12, 0, 1, '2025-11-11 22:48:52'),
(6, 'CRE-20251113-0003', 5, '2025-11-12', '08:30:00', '12:30:00', 15, 0, 1, '2025-11-11 22:48:52'),
(7, 'CRE-20251115-0001', 2, '2025-11-15', '09:00:00', '12:00:00', 10, 2, 1, '2025-11-13 11:40:32'),
(8, 'CRE-20251115-0002', 2, '2025-11-15', '09:00:00', '12:00:00', 10, 1, 1, '2025-11-13 11:45:53'),
(9, 'CRE-20251114-0001', 2, '2025-11-16', '09:00:00', '12:00:00', 10, 1, 1, '2025-11-14 17:38:51'),
(10, 'CRE-20251117-0001', 2, '2025-11-19', '02:54:00', '03:54:00', 10, 6, 1, '2025-11-17 21:54:54'),
(11, 'CRE-20251117-0002', 3, '2025-11-20', '03:55:00', '04:55:00', 14, 1, 1, '2025-11-17 21:55:31');

-- --------------------------------------------------------

--
-- Structure de la table `notification`
--

CREATE TABLE `notification` (
  `id` int(11) NOT NULL,
  `code_notification` varchar(30) NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `type` enum('CREATION','RAPPEL','APPEL','CONFIRMATION') NOT NULL,
  `methode` enum('SMS','WHATSAPP','EMAIL') DEFAULT 'SMS',
  `statut` enum('en_attente','envoye','echec') DEFAULT 'en_attente',
  `date_envoi` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_reception` timestamp NULL DEFAULT NULL,
  `tentatives` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Table des notifications envoyées aux patients';

--
-- Déchargement des données de la table `notification`
--

INSERT INTO `notification` (`id`, `code_notification`, `ticket_id`, `patient_id`, `message`, `type`, `methode`, `statut`, `date_envoi`, `date_reception`, `tentatives`) VALUES
(1, 'NOT-20251112-0001', 1, 8, 'Bonjour Omar, votre ticket T20251112-001 a été créé avec succès. RDV le 12/11/2025 à 09:00 avec Dr. Alami. Clinique Al Amal.', 'CREATION', 'SMS', 'envoye', '2025-11-11 22:48:52', NULL, 0),
(2, 'NOT-20251112-0002', 2, 9, 'Bonjour Sara, votre ticket T20251112-002 a été créé avec succès. RDV le 12/11/2025 à 09:00 avec Dr. Bennani. Clinique Al Amal.', 'CREATION', 'SMS', 'envoye', '2025-11-11 22:48:52', NULL, 0),
(3, 'NOT-20251112-0003', 3, 10, 'C\'est bientôt votre tour ! Ticket T20251112-003. Merci de vous présenter à l\'accueil.', 'APPEL', 'SMS', 'envoye', '2025-11-11 22:48:52', NULL, 0),
(4, 'NOT-20251113-6061', 4, 1, 'Bonjour Système, votre ticket T-20251113-0001 a été créé avec succès. Merci de consulter votre email pour les détails.', 'CREATION', 'SMS', 'en_attente', '2025-11-13 11:32:21', NULL, 0),
(5, 'NOT-20251113-5517', 5, 8, 'Bonjour Omar, votre ticket T-20251113-0002 a été créé avec succès. Merci de consulter votre email pour les détails.', 'CREATION', 'SMS', 'en_attente', '2025-11-13 11:40:32', NULL, 0),
(6, 'NOT-20251113-0047', 6, 8, 'Bonjour Omar, votre ticket T-20251113-0003 a été créé avec succès. Merci de consulter votre email pour les détails.', 'CREATION', 'SMS', 'en_attente', '2025-11-13 11:45:53', NULL, 0),
(7, 'NOT-20251114-4108', 7, 8, 'Bonjour Omar, votre ticket T-20251114-001 a été créé avec succès. Merci de consulter votre email pour les détails.', 'CREATION', 'SMS', 'en_attente', '2025-11-14 17:38:51', NULL, 0),
(8, 'NOT-20251114-0002', 7, 8, 'Votre ticket T-20251114-001 a été créé. RDV le 16/11/2025.', 'CREATION', 'SMS', 'en_attente', '2025-11-14 17:38:51', NULL, 0),
(9, 'NOT-20251117-7640', 8, 10, 'Bonjour Youssef, votre ticket T-20251117-001 a été créé avec succès. Merci de consulter votre email pour les détails.', 'CREATION', 'SMS', 'en_attente', '2025-11-17 21:55:54', NULL, 0),
(10, 'NOT-20251117-0002', 8, 10, 'Votre ticket T-20251117-001 a été créé avec succès.', 'CREATION', 'SMS', 'en_attente', '2025-11-17 21:55:54', NULL, 0),
(11, 'NOT-20251117-4026', 9, 10, 'Bonjour Youssef, votre ticket T-20251117-002 a été créé avec succès. Merci de consulter votre email pour les détails.', 'CREATION', 'SMS', 'en_attente', '2025-11-17 21:56:35', NULL, 0),
(12, 'NOT-20251117-0004', 9, 10, 'Votre ticket T-20251117-002 a été créé avec succès.', 'CREATION', 'SMS', 'en_attente', '2025-11-17 21:56:35', NULL, 0),
(13, 'NOT-20251117-1909', 10, 8, 'Bonjour Omar, votre ticket T-20251117-003 a été créé avec succès. Merci de consulter votre email pour les détails.', 'CREATION', 'SMS', 'en_attente', '2025-11-17 22:03:08', NULL, 0),
(14, 'NOT-20251117-5176', 11, 10, 'Bonjour Youssef, votre ticket T-20251117-004 a été créé avec succès. Merci de consulter votre email pour les détails.', 'CREATION', 'SMS', 'en_attente', '2025-11-17 22:45:11', NULL, 0),
(15, 'NOT-20251117-0007', 11, 10, 'Votre ticket T-20251117-004 a été créé avec succès.', 'CREATION', 'SMS', 'en_attente', '2025-11-17 22:45:11', NULL, 0),
(16, 'NOT-20251118-1640', 12, 14, 'Bonjour khadija, votre ticket T-20251118-001 a été créé avec succès. Merci de consulter votre email pour les détails.', 'CREATION', 'SMS', 'en_attente', '2025-11-17 23:04:27', NULL, 0),
(17, 'NOT-20251118-0002', 12, 14, 'Votre ticket T-20251118-001 a été créé avec succès.', 'CREATION', 'SMS', 'en_attente', '2025-11-17 23:04:27', NULL, 0),
(18, 'NOT-20251118-1231', 13, 8, 'Bonjour Omar, votre ticket T-20251118-002 a été créé avec succès. Merci de consulter votre email pour les détails.', 'CREATION', 'SMS', 'en_attente', '2025-11-17 23:06:57', NULL, 0),
(19, 'NOT-20251120-0286', 14, 8, 'Bonjour Omar, votre ticket T-20251120-001 a été créé avec succès. Merci de consulter votre email pour les détails.', 'CREATION', 'SMS', 'en_attente', '2025-11-20 18:28:48', NULL, 0),
(20, 'NOT-20251120-5997', 15, 8, 'Bonjour Omar, votre ticket T-20251120-002 a été créé avec succès. Merci de consulter votre email pour les détails.', 'CREATION', 'SMS', 'en_attente', '2025-11-20 18:29:04', NULL, 0),
(21, 'NOT-20251120-3584', 16, 8, 'Bonjour Omar, votre ticket T-20251120-003 a été créé avec succès. Merci de consulter votre email pour les détails.', 'CREATION', 'SMS', 'en_attente', '2025-11-20 18:38:02', NULL, 0);

-- --------------------------------------------------------

--
-- Structure de la table `specialite`
--

CREATE TABLE `specialite` (
  `id` int(11) NOT NULL,
  `code_specialite` varchar(20) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `actif` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Table des spécialités médicales';

--
-- Déchargement des données de la table `specialite`
--

INSERT INTO `specialite` (`id`, `code_specialite`, `nom`, `description`, `actif`, `created_at`) VALUES
(11, 'SPEC-001', 'Neurologie', 'Spécialité dans le diagnostic et le traitement des maladies du cerveau, de la moelle épinière et des nerfs', 1, '2025-11-21 00:00:03'),
(12, 'SPEC-002', 'Cardiologie', 'Spécialité dans le diagnostic et le traitement des maladies du cœur et des vaisseaux sanguins', 1, '2025-11-21 00:00:03'),
(13, 'SPEC-003', 'Pédiatrie', 'Spécialité médicale consacrée aux soins des nourrissons, enfants et adolescents', 1, '2025-11-21 00:00:03'),
(14, 'SPEC-004', 'Orthopédie', 'Spécialité dans le traitement des troubles de l\'appareil locomoteur', 1, '2025-11-21 00:00:03'),
(15, 'SPEC-005', 'Dermatologie', 'Spécialité dans le diagnostic et le traitement des maladies de la peau', 1, '2025-11-21 00:00:03'),
(16, 'SPEC-006', 'Ophtalmologie', 'Spécialité dans le diagnostic et le traitement des maladies des yeux', 1, '2025-11-21 00:00:03'),
(17, 'SPEC-007', 'Gynécologie', 'Spécialité dans le diagnostic et le traitement des maladies de l\'appareil génital féminin', 1, '2025-11-21 00:00:03'),
(18, 'SPEC-008', 'Psychiatrie', 'Spécialité dans le diagnostic et le traitement des troubles mentaux', 1, '2025-11-21 00:00:03'),
(19, 'SPEC-009', 'Radiologie', 'Spécialité dans l\'utilisation de l\'imagerie médicale pour le diagnostic', 1, '2025-11-21 00:00:03'),
(20, 'SPEC-010', 'Anesthésie', 'Spécialité dans l\'administration de l\'anesthésie et la gestion de la douleur', 1, '2025-11-21 00:00:03');

-- --------------------------------------------------------

--
-- Structure de la table `ticket`
--

CREATE TABLE `ticket` (
  `id` int(11) NOT NULL,
  `numero` varchar(20) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `medecin_id` int(11) NOT NULL,
  `creneau_id` int(11) NOT NULL,
  `statut` enum('en_attente','appele','present','en_consultation','termine','annule') DEFAULT 'en_attente',
  `date_creation` timestamp NOT NULL DEFAULT current_timestamp(),
  `heure_arrivee` time DEFAULT NULL,
  `priorite` int(11) DEFAULT 1
) ;

--
-- Déchargement des données de la table `ticket`
--

INSERT INTO `ticket` (`id`, `numero`, `patient_id`, `medecin_id`, `creneau_id`, `statut`, `date_creation`, `heure_arrivee`, `priorite`) VALUES
(1, 'T20251112-001', 8, 2, 1, '', '2025-11-11 22:48:52', NULL, 1),
(2, 'T20251112-002', 9, 3, 2, 'appele', '2025-11-11 22:48:52', NULL, 1),
(3, 'T20251112-003', 10, 2, 1, 'appele', '2025-11-11 22:48:52', NULL, 1),
(4, 'T-20251113-0001', 1, 2, 1, 'appele', '2025-11-13 11:32:21', NULL, 1),
(5, 'T-20251113-0002', 8, 2, 7, 'termine', '2025-11-13 11:40:32', NULL, 1),
(6, 'T-20251113-0003', 8, 2, 8, 'present', '2025-11-13 11:45:53', NULL, 1),
(7, 'T-20251114-001', 8, 2, 9, 'termine', '2025-11-14 17:38:51', NULL, 1),
(8, 'T-20251117-001', 10, 13, 10, 'en_attente', '2025-11-17 21:55:54', NULL, 2),
(9, 'T-20251117-002', 10, 2, 10, 'appele', '2025-11-17 21:56:35', NULL, 2),
(10, 'T-20251117-003', 8, 2, 10, 'termine', '2025-11-17 22:03:08', NULL, 1),
(11, 'T-20251117-004', 10, 2, 10, 'termine', '2025-11-17 22:45:11', NULL, 2),
(12, 'T-20251118-001', 14, 2, 10, 'termine', '2025-11-17 23:04:27', NULL, 2),
(13, 'T-20251118-002', 8, 2, 10, 'appele', '2025-11-17 23:06:57', NULL, 1),
(14, 'T-20251120-001', 8, 3, 11, 'annule', '2025-11-20 18:28:48', NULL, 2),
(15, 'T-20251120-002', 8, 3, 11, 'annule', '2025-11-20 18:29:04', NULL, 2),
(16, 'T-20251120-003', 8, 3, 11, 'en_attente', '2025-11-20 18:38:02', NULL, 2);

--
-- Déclencheurs `ticket`
--
DELIMITER $$
CREATE TRIGGER `after_ticket_insert` AFTER INSERT ON `ticket` FOR EACH ROW BEGIN
    -- Incrémenter le nombre de tickets pris
    UPDATE creneau 
    SET tickets_pris = tickets_pris + 1,
        disponible = CASE 
            WHEN (tickets_pris + 1) >= capacite THEN FALSE 
            ELSE TRUE 
        END
    WHERE id = NEW.creneau_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_ticket_insert_notification` AFTER INSERT ON `ticket` FOR EACH ROW BEGIN
    DECLARE msg TEXT;
    DECLARE code_notif VARCHAR(30);
    DECLARE patient_nom VARCHAR(100);
    DECLARE patient_prenom VARCHAR(100);
    
    -- Récupérer le nom du patient
    SELECT nom, prenom INTO patient_nom, patient_prenom
    FROM user WHERE id = NEW.patient_id;
    
    -- Générer le code de notification
    SET code_notif = CONCAT('NOT-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', 
                           LPAD(FLOOR(RAND() * 10000), 4, '0'));
    
    -- Créer le message
    SET msg = CONCAT('Bonjour ', patient_prenom, ', votre ticket ', NEW.numero, 
                    ' a été créé avec succès. Merci de consulter votre email pour les détails.');
    
    -- Insérer la notification
    INSERT INTO notification (code_notification, ticket_id, patient_id, message, type, statut)
    VALUES (code_notif, NEW.id, NEW.patient_id, msg, 'CREATION', 'en_attente');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_ticket_update` AFTER UPDATE ON `ticket` FOR EACH ROW BEGIN
    IF NEW.statut = 'annule' AND OLD.statut != 'annule' THEN
        -- Décrémenter le nombre de tickets pris
        UPDATE creneau 
        SET tickets_pris = tickets_pris - 1,
            disponible = TRUE
        WHERE id = NEW.creneau_id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `code_user` varchar(20) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `telephone` varchar(20) DEFAULT NULL,
  `role` enum('PATIENT','MEDECIN','SECRETAIRE','ADMIN') NOT NULL,
  `actif` tinyint(1) DEFAULT 1,
  `specialite_id` int(11) DEFAULT NULL,
  `numero_ordre` varchar(50) DEFAULT NULL,
  `numero_securite_sociale` varchar(50) DEFAULT NULL,
  `date_naissance` date DEFAULT NULL,
  `adresse` text DEFAULT NULL,
  `groupe_sanguin` varchar(5) DEFAULT NULL,
  `service` varchar(100) DEFAULT NULL,
  `niveau` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Table des utilisateurs (Patient, Médecin, Secrétaire, Admin)';

--
-- Déchargement des données de la table `user`
--

INSERT INTO `user` (`id`, `code_user`, `nom`, `prenom`, `email`, `password`, `telephone`, `role`, `actif`, `specialite_id`, `numero_ordre`, `numero_securite_sociale`, `date_naissance`, `adresse`, `groupe_sanguin`, `service`, `niveau`, `created_at`) VALUES
(1, 'ADM-0001', 'Admin', 'Système', 'admin@clinic.ma', 'admin123', '0612345678', 'ADMIN', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Super Admin', '2025-11-11 22:48:52'),
(2, 'MED-0001', 'Alami', 'Hassan', 'h.alami@clinic.ma', 'pass123', '0623456789', 'MEDECIN', 1, NULL, 'ORD-12345', NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-11 22:48:52'),
(3, 'MED-0002', 'Bennani', 'Fatima', 'f.bennani@clinic.ma', 'pass123', '0634567890', 'MEDECIN', 1, NULL, 'ORD-67890', NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-11 22:48:52'),
(4, 'MED-0003', 'Tazi', 'Mehdi', 'm.tazi@clinic.ma', 'pass123', '0645678901', 'MEDECIN', 1, NULL, 'ORD-11111', NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-11 22:48:52'),
(5, 'MED-0004', 'Idrissi', 'Karim', 'k.idrissi@clinic.ma', 'pass123', '0656789012', 'MEDECIN', 1, NULL, 'ORD-22222', NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-11 22:48:52'),
(6, 'SEC-0001', 'Filali', 'Amina', 'a.filali@clinic.ma', 'pass123', '0667890123', 'SECRETAIRE', 1, NULL, NULL, NULL, NULL, NULL, NULL, 'Accueil', NULL, '2025-11-11 22:48:52'),
(7, 'SEC-0002', 'Tazi', 'Salma', 's.tazi@clinic.ma', 'pass123', '0678901234', 'SECRETAIRE', 1, NULL, NULL, NULL, NULL, NULL, NULL, 'Consultations', NULL, '2025-11-11 22:48:52'),
(8, 'PAT-0001', 'Khalil', 'Omar', 'o.khalil@gmail.com', 'pass123', '0689012345', 'PATIENT', 1, NULL, NULL, 'NSS-123456', '1990-05-15', 'Rue 10, Casablanca', 'A+', NULL, NULL, '2025-11-11 22:48:52'),
(9, 'PAT-0002', 'Bennis', 'Sara', 's.bennis@gmail.com', 'pass123', '0690123456', 'PATIENT', 1, NULL, NULL, 'NSS-234567', '1985-08-22', 'Avenue Mohammed V, Rabat', 'O+', NULL, NULL, '2025-11-11 22:48:52'),
(10, 'PAT-0003', 'Alaoui', 'Youssef', 'y.alaoui@gmail.com', 'pass123', '0601234567', 'PATIENT', 1, NULL, NULL, 'NSS-345678', '2000-12-10', 'Boulevard Hassan II, Salé', 'B+', NULL, NULL, '2025-11-11 22:48:52'),
(11, 'PAT-0004', 'Amrani', 'Leila', 'l.amrani@gmail.com', 'pass123', '0612345670', 'PATIENT', 1, NULL, NULL, 'NSS-456789', '1995-03-25', 'Rue Allal Ben Abdellah, Témara', 'AB+', NULL, NULL, '2025-11-11 22:48:52'),
(12, 'PAT-0005', 'BENALI', 'Fatima', 'f.benali@gmail.com', '123456', '0699999999', 'PATIENT', 0, NULL, NULL, 'NSS-123456', '1990-05-15', 'Rabat, Maroc', 'A+', NULL, NULL, '2025-11-13 11:29:10'),
(13, 'MED-0005', 'ALAMI', 'Hassan', 'h.alami@clinique.ma', 'medecin123', '0698765432', 'MEDECIN', 1, NULL, 'ORD-2024-001', NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-13 11:29:10'),
(14, 'PAT-0006', 'test', 'khadija', 'k.test@gmail.ma', 'pass123', '0660739792', 'PATIENT', 1, NULL, NULL, 'CDSER34', '2004-09-21', 'ecole abdelmajid agadir', 'O+', NULL, NULL, '2025-11-17 23:03:33'),
(15, 'PAT-0007', 'rachidi', 'rachida', 'rachida13@gmail.ma', 'pass123', '0660739792', 'PATIENT', 1, NULL, NULL, 'NSS-23426', '1970-12-13', 'jardin de souss app2 gr1', 'O-', NULL, NULL, '2025-11-20 23:05:54');

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_consultations_detaillees`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_consultations_detaillees` (
`id` int(11)
,`code_consultation` varchar(30)
,`date_consultation` timestamp
,`duree_consultation` int(11)
,`statut` enum('en_cours','terminee')
,`ticket` varchar(20)
,`code_patient` varchar(20)
,`patient` varchar(201)
,`code_medecin` varchar(20)
,`medecin` varchar(201)
,`specialite` varchar(100)
,`symptomes` text
,`diagnostic` text
,`prescription` text
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_creneaux_disponibles`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_creneaux_disponibles` (
`id` int(11)
,`code_creneau` varchar(30)
,`date` date
,`heure_debut` time
,`heure_fin` time
,`capacite` int(11)
,`tickets_pris` int(11)
,`places_restantes` bigint(12)
,`disponible` tinyint(1)
,`code_medecin` varchar(20)
,`medecin` varchar(201)
,`specialite` varchar(100)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_medecins_specialites`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_medecins_specialites` (
`id` int(11)
,`code_user` varchar(20)
,`nom_complet` varchar(201)
,`email` varchar(150)
,`telephone` varchar(20)
,`numero_ordre` varchar(50)
,`code_specialite` varchar(20)
,`specialite` varchar(100)
,`specialite_description` text
,`actif` tinyint(1)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_tickets_complets`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_tickets_complets` (
`id` int(11)
,`numero` varchar(20)
,`statut` enum('en_attente','appele','present','en_consultation','termine','annule')
,`priorite` int(11)
,`date_creation` timestamp
,`heure_arrivee` time
,`code_patient` varchar(20)
,`patient` varchar(201)
,`tel_patient` varchar(20)
,`email_patient` varchar(150)
,`code_medecin` varchar(20)
,`medecin` varchar(201)
,`specialite` varchar(100)
,`code_creneau` varchar(30)
,`date_creneau` date
,`heure_debut` time
,`heure_fin` time
);

-- --------------------------------------------------------

--
-- Structure de la vue `v_consultations_detaillees`
--
DROP TABLE IF EXISTS `v_consultations_detaillees`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_consultations_detaillees`  AS SELECT `cons`.`id` AS `id`, `cons`.`code_consultation` AS `code_consultation`, `cons`.`date_consultation` AS `date_consultation`, `cons`.`duree_consultation` AS `duree_consultation`, `cons`.`statut` AS `statut`, `t`.`numero` AS `ticket`, `p`.`code_user` AS `code_patient`, concat(`p`.`prenom`,' ',`p`.`nom`) AS `patient`, `m`.`code_user` AS `code_medecin`, concat(`m`.`prenom`,' ',`m`.`nom`) AS `medecin`, `s`.`nom` AS `specialite`, `cons`.`symptomes` AS `symptomes`, `cons`.`diagnostic` AS `diagnostic`, `cons`.`prescription` AS `prescription` FROM ((((`consultation` `cons` join `ticket` `t` on(`cons`.`ticket_id` = `t`.`id`)) join `user` `p` on(`cons`.`patient_id` = `p`.`id`)) join `user` `m` on(`cons`.`medecin_id` = `m`.`id`)) join `specialite` `s` on(`m`.`specialite_id` = `s`.`id`)) ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_creneaux_disponibles`
--
DROP TABLE IF EXISTS `v_creneaux_disponibles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_creneaux_disponibles`  AS SELECT `c`.`id` AS `id`, `c`.`code_creneau` AS `code_creneau`, `c`.`date` AS `date`, `c`.`heure_debut` AS `heure_debut`, `c`.`heure_fin` AS `heure_fin`, `c`.`capacite` AS `capacite`, `c`.`tickets_pris` AS `tickets_pris`, `c`.`capacite`- `c`.`tickets_pris` AS `places_restantes`, `c`.`disponible` AS `disponible`, `m`.`code_user` AS `code_medecin`, concat(`m`.`prenom`,' ',`m`.`nom`) AS `medecin`, `s`.`nom` AS `specialite` FROM ((`creneau` `c` join `user` `m` on(`c`.`medecin_id` = `m`.`id`)) join `specialite` `s` on(`m`.`specialite_id` = `s`.`id`)) WHERE `c`.`disponible` = 1 AND `c`.`date` >= curdate() ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_medecins_specialites`
--
DROP TABLE IF EXISTS `v_medecins_specialites`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_medecins_specialites`  AS SELECT `u`.`id` AS `id`, `u`.`code_user` AS `code_user`, concat(`u`.`prenom`,' ',`u`.`nom`) AS `nom_complet`, `u`.`email` AS `email`, `u`.`telephone` AS `telephone`, `u`.`numero_ordre` AS `numero_ordre`, `s`.`code_specialite` AS `code_specialite`, `s`.`nom` AS `specialite`, `s`.`description` AS `specialite_description`, `u`.`actif` AS `actif` FROM (`user` `u` join `specialite` `s` on(`u`.`specialite_id` = `s`.`id`)) WHERE `u`.`role` = 'MEDECIN' ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_tickets_complets`
--
DROP TABLE IF EXISTS `v_tickets_complets`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_tickets_complets`  AS SELECT `t`.`id` AS `id`, `t`.`numero` AS `numero`, `t`.`statut` AS `statut`, `t`.`priorite` AS `priorite`, `t`.`date_creation` AS `date_creation`, `t`.`heure_arrivee` AS `heure_arrivee`, `p`.`code_user` AS `code_patient`, concat(`p`.`prenom`,' ',`p`.`nom`) AS `patient`, `p`.`telephone` AS `tel_patient`, `p`.`email` AS `email_patient`, `m`.`code_user` AS `code_medecin`, concat(`m`.`prenom`,' ',`m`.`nom`) AS `medecin`, `s`.`nom` AS `specialite`, `c`.`code_creneau` AS `code_creneau`, `c`.`date` AS `date_creneau`, `c`.`heure_debut` AS `heure_debut`, `c`.`heure_fin` AS `heure_fin` FROM ((((`ticket` `t` join `user` `p` on(`t`.`patient_id` = `p`.`id`)) join `user` `m` on(`t`.`medecin_id` = `m`.`id`)) join `specialite` `s` on(`m`.`specialite_id` = `s`.`id`)) join `creneau` `c` on(`t`.`creneau_id` = `c`.`id`)) ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `consultation`
--
ALTER TABLE `consultation`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code_consultation` (`code_consultation`),
  ADD UNIQUE KEY `ticket_id` (`ticket_id`),
  ADD KEY `idx_code` (`code_consultation`),
  ADD KEY `idx_medecin` (`medecin_id`),
  ADD KEY `idx_patient` (`patient_id`),
  ADD KEY `idx_date` (`date_consultation`);

--
-- Index pour la table `creneau`
--
ALTER TABLE `creneau`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code_creneau` (`code_creneau`),
  ADD KEY `idx_medecin` (`medecin_id`),
  ADD KEY `idx_date` (`date`),
  ADD KEY `idx_code` (`code_creneau`),
  ADD KEY `idx_disponible` (`disponible`);

--
-- Index pour la table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code_notification` (`code_notification`),
  ADD KEY `ticket_id` (`ticket_id`),
  ADD KEY `idx_code` (`code_notification`),
  ADD KEY `idx_statut` (`statut`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_patient` (`patient_id`);

--
-- Index pour la table `specialite`
--
ALTER TABLE `specialite`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code_specialite` (`code_specialite`),
  ADD UNIQUE KEY `nom` (`nom`),
  ADD KEY `idx_code` (`code_specialite`),
  ADD KEY `idx_nom` (`nom`);

--
-- Index pour la table `ticket`
--
ALTER TABLE `ticket`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero` (`numero`),
  ADD KEY `idx_statut` (`statut`),
  ADD KEY `idx_numero` (`numero`),
  ADD KEY `idx_patient` (`patient_id`),
  ADD KEY `idx_medecin` (`medecin_id`),
  ADD KEY `idx_creneau` (`creneau_id`),
  ADD KEY `idx_date` (`date_creation`);

--
-- Index pour la table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code_user` (`code_user`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_role` (`role`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_code` (`code_user`),
  ADD KEY `idx_specialite` (`specialite_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `consultation`
--
ALTER TABLE `consultation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `creneau`
--
ALTER TABLE `creneau`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `notification`
--
ALTER TABLE `notification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT pour la table `specialite`
--
ALTER TABLE `specialite`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT pour la table `ticket`
--
ALTER TABLE `ticket`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `consultation`
--
ALTER TABLE `consultation`
  ADD CONSTRAINT `consultation_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `consultation_ibfk_2` FOREIGN KEY (`medecin_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `consultation_ibfk_3` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `creneau`
--
ALTER TABLE `creneau`
  ADD CONSTRAINT `creneau_ibfk_1` FOREIGN KEY (`medecin_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `notification`
--
ALTER TABLE `notification`
  ADD CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notification_ibfk_2` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `ticket`
--
ALTER TABLE `ticket`
  ADD CONSTRAINT `ticket_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ticket_ibfk_2` FOREIGN KEY (`medecin_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ticket_ibfk_3` FOREIGN KEY (`creneau_id`) REFERENCES `creneau` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`specialite_id`) REFERENCES `specialite` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
