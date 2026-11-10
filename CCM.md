# Documentation Complète — NathBank & NathStore & NathNotes & NathChat
## Guide de A à Z — Tout ce qu'il faut savoir sur l'écosystème KernelAndCo


---

## 1. Vue d'ensemble du projet

NathBank & NathStore & NathNotes & NathChat est un écosystème **full-stack** complet, développé de zéro sans framework frontend. Il se compose de 4 modules qui communiquent entre eux :

- **NathBank** : une banque en ligne (frontend + backend)
- **NathStore** : une boutique e-commerce qui paye via NathBank
- **NathProject** : un portail SNT de présentation du projet (index.html à la racine)
- **NathNotes** : une application de notes style Apple Notes (backend + frontend)
- **NathChat** : une messagerie temps réel avec WebSockets (backend + frontend)

Le tout tourne sur une seule machine en local.

---

## 2. Stack technique

| Outil | Rôle | Version |
|-------|------|---------|
| Node.js | Exécuter les serveurs backend | v24.14.0 |
| Express | Framework HTTP pour les API REST | npm |
| sql.js | Base de données SQLite en mémoire (WebAssembly) | npm |
| bcrypt | Hasher les mots de passe | npm |
| jsonwebtoken (JWT) | Authentification sécurisée | npm |
| cookie-parser | Lecture des cookies httpOnly (NathNotes) | npm |
| express-rate-limit | Limitation de tentative de connexion (NathNotes) | npm |
| ws | WebSocket serveur (NathChat) | npm |
| HTML/CSS/JS vanilla | Tout le frontend | ES2022 |
| VS Code + Live Server | Environnement de dev | port 5500 |

---

## 3. Structure des fichiers

```
projet-banque/
├── CCM.md                    ← Documentation
├── index.html                ← Portail SNT / Landing page NathProject (racine)
├── secret.html               ← Portail SNT (ancien)
├── ADMIN.md                  ← Identifiants et clés secrètes
├── arbo.txt                  ← Arborescence du projet
├── ReadMe.md                 ← Note de rappel
├── skills.md                 ← Fiche compétence design frontend
├── .env                      ← Variables d'environnement (GITHUB_TOKEN)
├── .gitignore                ← Fichiers ignorés par Git
├── start-all.bat             ← Script de lancement Windows (tous les serveurs)
│
├── banque/                   ← BACKEND NathBank (tout le serveur, port 3000)
│   ├── index.js             ← Point d'entrée du serveur + routes GitHub stats
│   ├── database.js          ← Gestion SQLite
│   ├── banque.db            ← Fichier base de données
│   ├── seed.js              ← Script pour remplir la BDD de produits
│   ├── start.bat            ← Script de lancement Windows (serveur Banque)
│   ├── start.ps1            ← Script de lancement PowerShell (serveur Banque)
│   ├── .env                 ← Variables d'environnement (GITHUB_TOKEN)
│   ├── package.json
│   ├── package-lock.json
│   ├── clear-all.js         ← Supprimer toutes les données de la BDD
│   ├── clear-categories.js  ← Supprimer les catégories
│   ├── clear-commandes.js   ← Supprimer les commandes
│   ├── clear-paniers.js     ← Supprimer les paniers
│   ├── clear-produits.js    ← Supprimer les produits
│   ├── clear-transactions.js ← Supprimer les transactions
│   ├── clear-users.js       ← Supprimer les utilisateurs
│   ├── middleware/
│   │   └── auth.js          ← Vérification JWT
│   ├── routes/
│   │   ├── auth.js          ← Inscription / Connexion
│   │   ├── comptes.js       ← Solde et dépôt
│   │   ├── transactions.js  ← Paiements et historique
│   │   ├── admin.js         ← Gestion produits NathStore
│   │   ├── categories.js    ← Gestion catégories dynamiques
│   │   ├── panier.js        ← Panier persistant en BDD
│   │   └── commandes.js     ← Historique des commandes
│   └── node_modules/
│
├── banque-frontend/          ← FRONTEND NathBank
│   ├── index.html           ← Page connexion / inscription
│   ├── dashboard.html       ← Dashboard utilisateur
│   └── paiement.html        ← Page de confirmation paiement
│
├── nathstore/               ← FRONTEND NathStore
│   ├── index.html           ← Boutique
│   ├── admin.html           ← Panel admin
│   └── admin-help.html      ← Guide import JSON
│
├── nathnotes/               ← BACKEND + FRONTEND NathNotes (port 3001)
│   ├── server.js            ← Serveur Express + API REST
│   ├── index.html           ← Application de notes (3 panneaux)
│   ├── help.html            ← Guide d'utilisation
│   ├── nathnotes.db         ← Fichier base de données
│   ├── package.json
│   ├── package-lock.json
│   └── node_modules/
│
└── nathchat/               ← BACKEND + FRONTEND NathChat (port 3002, WebSocket)
    ├── server.js            ← Serveur Express + WebSocket
    ├── package.json
    ├── README.md
    ├── public/
    │   └── index.html       ← Interface de chat
    └── node_modules/
```

---

## 4. Les serveurs et ports

| Service | Port | URL |
|---------|------|-----|
| NathBank API | 3000 | `http://localhost:3000` |
| NathNotes API | 3001 | `http://localhost:3001` |
| NathChat API + WS | 3002 | `http://localhost:3002` |
| Frontend (Live Server) | 5500 | `http://127.0.0.1:5500` |

### Lancement avec start-all.bat (Windows)

```bash
# Depuis la racine du projet
start-all.bat
```

Ce script lance :
1. Le serveur Banque (port 3000)
2. Le serveur NathNotes (port 3001)
3. Ouvre NathBank, NathStore et NathNotes dans le navigateur

### Lancement manuel

```bash
# 1. Serveur Banque (port 3000)
cd banque
node index.js

# 2. Serveur NathNotes (port 3001)
cd nathnotes
node server.js

# 3. Serveur NathChat (port 3002)
cd nathchat
node server.js

# 4. Ouvrir les frontends avec VS Code Live Server sur le port 5500
```

**URLs importantes :**
- NathBank : `http://127.0.0.1:5500/banque-frontend`
- NathStore : `http://127.0.0.1:5500/nathstore`
- NathNotes : `http://127.0.0.1:5500/nathnotes`
- NathChat : `http://127.0.0.1:5500/nathchat`
- Portail SNT : `http://127.0.0.1:5500/index.html`
- API Banque : `http://localhost:3000`
- API Notes : `http://localhost:3001`
- API Chat : `http://localhost:3002`

---

## 5. Le Backend NathBank — Comment ça marche

### 5.1 index.js — Le cerveau du serveur

`index.js` est le fichier principal. Il fait plusieurs choses :
1. Charge les variables d'environnement (`.env`)
2. Crée l'application Express
3. Active CORS (pour que le frontend puisse communiquer avec le backend malgré les différents ports)
4. Importe et branche toutes les routes API
5. Ajoute les routes GitHub stats et commits
6. Initialise la base de données
7. Lance le serveur sur le port 3000

```javascript
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const db = require('./database');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

// Branchement des routes
app.use('/api/auth', authRoutes);
app.use('/api/comptes', comptesRoutes);
app.use('/api/transactions', transactionsRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/panier', panierRoutes);
app.use('/api/commandes', commandesRoutes);
app.use('/api/categories', categoriesRoutes);

// Routes GitHub stats
app.get('/api/github-stats', ...);
app.get('/api/github-commits', ...);

// Démarrage
db.initDatabase().then(() => app.listen(3000));
```

### 5.2 database.js — La base de données

Le projet utilise **sql.js**, une version de SQLite qui fonctionne en JavaScript pur (WebAssembly). Contrairement à SQLite classique, sql.js charge toute la BDD en mémoire RAM et la sauvegarde dans un fichier `.db` à chaque modification.

**Fonctionnement :**
- Au démarrage, si `banque.db` existe, il le charge en mémoire
- Sinon, il crée une nouvelle base vide
- Après chaque requête d'écriture (`INSERT`, `UPDATE`, `DELETE`), il sauvegarde automatiquement le fichier

**Les 8 tables créées automatiquement :**

```sql
users              -- Comptes utilisateurs
comptes            -- Comptes bancaires (solde)
transactions       -- Historique des paiements
produits           -- Produits NathStore
categories         -- Catégories dynamiques
admins             -- Comptes administrateurs
paniers            -- Paniers sauvegardés
commandes          -- Commandes passées
commandes_items    -- Détail de chaque commande
```

**Les 3 fonctions utilitaires exposées :**
- `run(sql, params)` — Exécute une requête sans retour (INSERT, UPDATE, DELETE)
- `get(sql, params)` — Retourne une seule ligne
- `all(sql, params)` — Retourne toutes les lignes correspondantes

### 5.3 middleware/auth.js — L'authentification JWT

Un **middleware** c'est une fonction qui s'exécute entre la requête et la réponse. `auth.js` vérifie que l'utilisateur est bien connecté avant d'accéder aux routes protégées.

**Comment ça marche :**
1. Le client envoie une requête avec un header `Authorization: Bearer <token>`
2. Le middleware extrait le token
3. Il le vérifie avec la clé secrète JWT
4. Si valide, il met l'utilisateur dans `req.user` et laisse passer
5. Si invalide, il retourne une erreur 401

**Deux secrets JWT distincts :**
- Users : `mon_secret_jwt_super_secure_123`
- Admins : `admin_secret_nathstore_456`

---

## 6. Les Routes API NathBank — Toutes les endpoints

### 6.1 Auth (`/api/auth`)

#### POST `/api/auth/register`
Créer un nouveau compte utilisateur.

**Body requis :**
```json
{
  "nom": "Nathanael",
  "email": "nath@mail.com",
  "mot_de_passe": "1234"
}
```

**Ce que ça fait :**
1. Vérifie que tous les champs sont présents
2. Hash le mot de passe avec bcrypt (coût 10)
3. Insère l'utilisateur en BDD
4. Crée automatiquement un compte bancaire avec **100€ de solde de départ**
5. Retourne un message de confirmation

---

#### POST `/api/auth/login`
Se connecter.

**Body requis :**
```json
{
  "email": "nath@mail.com",
  "mot_de_passe": "1234"
}
```

**Ce que ça fait :**
1. Cherche l'utilisateur par email
2. Compare le mot de passe avec le hash bcrypt
3. Si correct, génère un token JWT valable 24h
4. Retourne le token + le nom de l'utilisateur

**Réponse :**
```json
{
  "message": "✅ Connecté !",
  "token": "eyJhbGci...",
  "nom": "Nathanael"
}
```

---

### 6.2 Comptes (`/api/comptes`) — Protégé JWT

#### GET `/api/comptes/solde`
Retourne le solde du compte connecté.

#### POST `/api/comptes/deposer`
Déposer de l'argent sur son compte.

**Body :**
```json
{ "montant": 500 }
```

**Règle :** Maximum 10 000€ de solde. Si le dépôt dépasse cette limite, il est refusé.

---

### 6.3 Transactions (`/api/transactions`) — Protégé JWT

#### POST `/api/transactions/payer`
Effectuer un paiement (débite le compte).

**Body :**
```json
{
  "montant": 89.99,
  "description": "Air Max 2026 x1, USB-C Hub x2"
}
```

**Ce que ça fait :**
1. Vérifie que le solde est suffisant
2. Débite le compte
3. Enregistre la transaction en BDD
4. Retourne le nouveau solde

---

#### GET `/api/transactions/historique`
Retourne l'historique de toutes les transactions du compte connecté.

---

### 6.4 Admin (`/api/admin`)

#### POST `/api/admin/setup`
Créer le premier compte admin (protégé par une clé secrète).

**Body :**
```json
{
  "email": "admin@nathstore.com",
  "mot_de_passe": "admin2026",
  "secret": "NATHSTORE_ADMIN_2026"
}
```

#### POST `/api/admin/login`
Connexion admin (retourne un token JWT admin).

#### GET `/api/admin/produits`
Liste tous les produits (**route publique**, utilisée par le shop).

#### POST `/api/admin/produits` — Protégé JWT admin
Ajouter un produit.

**Body :**
```json
{
  "nom": "Air Max 2026",
  "emoji": "👟",
  "categorie": "mode",
  "prix": 89.99,
  "description": "Sneakers ultra confortables",
  "badge": "NEW"
}
```

#### PUT `/api/admin/produits/:id` — Protégé JWT admin
Modifier un produit existant.

#### DELETE `/api/admin/produits/:id` — Protégé JWT admin
Supprimer un produit.

---

### 6.5 Catégories (`/api/categories`)

#### GET `/api/categories`
Liste toutes les catégories triées par ordre (**route publique**).

**Retourne :**
```json
[
  { "id": 1, "nom": "mode", "emoji": "👟", "ordre": 1 },
  { "id": 2, "nom": "tech", "emoji": "💻", "ordre": 2 }
]
```

#### POST `/api/categories` — Protégé JWT admin
Ajouter une catégorie.

**Body :**
```json
{
  "nom": "sport",
  "emoji": "⚽",
  "ordre": 5
}
```

**Règle :** Le nom doit être en minuscules, sans espaces ni caractères spéciaux.

#### PUT `/api/categories/:id` — Protégé JWT admin
Modifier une catégorie.

#### DELETE `/api/categories/:id` — Protégé JWT admin
Supprimer une catégorie. **Refusé si des produits utilisent encore cette catégorie.**

---

### 6.6 Panier (`/api/panier`) — Protégé JWT

#### GET `/api/panier`
Récupère le panier sauvegardé de l'utilisateur connecté.

#### POST `/api/panier`
Sauvegarde/remplace le panier complet.

**Body :**
```json
{
  "items": [
    { "produit_id": 1, "quantite": 2 },
    { "produit_id": 5, "quantite": 1 }
  ]
}
```

**Ce que ça fait :** Supprime l'ancien panier et insère les nouveaux items.

#### DELETE `/api/panier`
Vide le panier.

---

### 6.7 Commandes (`/api/commandes`) — Protégé JWT

#### GET `/api/commandes`
Retourne toutes les commandes de l'utilisateur avec le détail des produits.

#### POST `/api/commandes`
Enregistre une nouvelle commande après paiement.

**Body :**
```json
{
  "total": 179.98,
  "items": [
    {
      "produit_id": 1,
      "nom": "Air Max 2026",
      "emoji": "👟",
      "prix": 89.99,
      "quantite": 2
    }
  ]
}
```

**Ce que ça fait :**
1. Crée la commande en BDD
2. Insère chaque item dans `commandes_items`
3. Vide automatiquement le panier

---

### 6.8 Routes GitHub (port 3000)

#### GET `/api/github-stats`
Retourne les statistiques du dépôt GitHub (langages, nombre total de commits). Utilise le token `GITHUB_TOKEN` du `.env`.

#### GET `/api/github-commits`
Retourne les 10 derniers commits du dépôt GitHub.

---

## 7. Frontend NathBank

### 7.1 banque-frontend/index.html — Connexion / Inscription

Page d'accueil de NathBank. Permet de :
- Se connecter à un compte existant
- Créer un nouveau compte

**Ce qui se passe techniquement lors de la connexion :**
1. L'utilisateur entre email + mot de passe
2. Le JS fait un `fetch` sur `POST /api/auth/login`
3. Si succès, le token JWT est sauvegardé dans `localStorage`
4. L'utilisateur est redirigé vers `dashboard.html`

**Design :** noir & or luxueux, font Cormorant Garamond.

---

### 7.2 banque-frontend/dashboard.html — Tableau de bord

Page principale de l'utilisateur connecté. Affiche :
- Le solde disponible
- Le total dépensé
- Le nombre de transactions
- L'historique complet des transactions
- Un bouton "Déposer" (ouvre une modal)

**Au chargement de la page :**
1. Récupère le token depuis `localStorage`
2. Fait `GET /api/comptes/solde` pour le solde
3. Fait `GET /api/transactions/historique` pour l'historique
4. Affiche tout dynamiquement

---

### 7.3 banque-frontend/paiement.html — Confirmation de paiement

Page animée qui confirme qu'un paiement a été effectué. Reçoit les informations via les paramètres d'URL.

---

## 8. Frontend NathStore

### 8.1 nathstore/index.html — La boutique

Page principale du shop. Fonctionnalités complètes :

**Chargement initial :**
1. Charge les catégories depuis `GET /api/categories`
2. Génère dynamiquement les boutons de filtre (nav + pills)
3. Charge les produits depuis `GET /api/admin/produits`
4. Si l'utilisateur est connecté (token dans `localStorage`), charge son panier depuis la BDD

**Filtrage par catégorie :**
- Clic sur une catégorie → filtre les produits affichés
- Les boutons nav et pills sont synchronisés

**Login obligatoire pour acheter :**
- Clic sur "+" sans être connecté → ouvre la modal de connexion
- Une fois connecté, le panier est chargé depuis la BDD

**Panier sidebar :**
- S'ouvre en glissant depuis la droite
- Permet de modifier les quantités
- Sauvegarde automatiquement en BDD à chaque modification (`POST /api/panier`)
- Affiche le total en temps réel

**Paiement :**
1. Clic sur "Payer avec NathBank"
2. Modal de confirmation affiche le total et le nom de l'utilisateur
3. Clic "Confirmer" → `POST /api/transactions/payer`
4. Si succès → `POST /api/commandes` pour enregistrer
5. Panier vidé, message de confirmation avec nouveau solde

**Historique des commandes :**
- Bouton "Commandes" dans la nav (visible si connecté)
- Modal avec toutes les commandes passées

**Dark/Light mode :**
- Toggle dans la nav, change le thème via `data-theme` sur `<html>`

---

### 8.2 nathstore/admin.html — Panel d'administration

Accessible sur `http://127.0.0.1:5500/nathstore/admin.html`

**Connexion :**
- Email : `admin@nathstore.com`
- Mot de passe : `admin2026`
- Token admin stocké dans `localStorage` (`adminToken`)

**Section Catégories :**
- Affichage de toutes les catégories sous forme de cards
- Formulaire pour ajouter une catégorie (nom + emoji + ordre)
- Bouton modifier (ouvre une modal)
- Bouton supprimer (bloqué si des produits utilisent la catégorie)

**Section Import JSON :**
- **Onglet "Coller du JSON"** : textarea pour coller directement du JSON
- **Onglet "Uploader un fichier"** : drag & drop ou sélection d'un fichier `.json`
- Barre de progression pendant l'import
- Message de confirmation avec nombre de produits importés / ignorés

**Format JSON attendu pour l'import :**
```json
[
  {
    "nom": "Air Max 2026",
    "emoji": "👟",
    "categorie": "mode",
    "prix": 89.99,
    "description": "Sneakers ultra confortables",
    "badge": "NEW"
  }
]
```

**Champs requis :** `nom`, `emoji`, `categorie`, `prix`
**Champs optionnels :** `description`, `badge`

**Section Ajouter un produit :**
- Formulaire manuel pour ajouter un produit
- Le select de catégorie est chargé dynamiquement depuis l'API

**Section Gérer les produits :**
- Tableau avec tous les produits
- Bouton "Modifier" → modal d'édition complète
- Bouton "Supprimer" → confirmation avant suppression

**Stats en haut :**
- Total produits
- Produits actifs
- Prix moyen
- Nombre de catégories

---

### 8.3 nathstore/admin-help.html — Guide d'import JSON

Page de documentation complète expliquant :
- Le format JSON attendu
- Description de chaque champ
- Les catégories disponibles
- Des exemples copiables en un clic
- Les erreurs fréquentes
- Des conseils et astuces

---

## 9. Backend NathNotes — API de notes (port 3001)

### 9.1 server.js — Le serveur NathNotes

`server.js` est le fichier principal de NathNotes. Il fait plusieurs choses :
1. Crée l'application Express avec CORS et cookie-parser
2. Initialise la base de données sql.js (`nathnotes.db`)
3. Configure le rate limiting sur les routes d'authentification (5 tentatives par IP par 15 min)
4. Branche toutes les routes API (auth, notes, dossiers)
5. Lance le serveur sur le port 3001

**Base de données :** sql.js avec fichier `nathnotes.db` persistant.

**Les 3 tables créées automatiquement :**

```sql
users    -- Comptes utilisateurs (email, password hashé, name, created_at)
notes    -- Notes utilisateurs (titre, content, folder, favorite, deleted, timestamps)
folders  -- Dossiers personnalisés (name, icon, color, user_id)
```

**Clé JWT :** `nathnotes_secret_key_2026`
**Authentification :** cookie `token` (httpOnly) OU header `Authorization: Bearer <token>`
**Expiration du token :** 7 jours

### 9.2 Routes API NathNotes

#### Auth (`/api/auth`)

| Méthode | Route | Auth | Description |
|---------|-------|------|-------------|
| POST | `/api/auth/register` | — | Créer un compte |
| POST | `/api/auth/login` | — | Connexion (rate-limited) |
| GET | `/api/auth/me` | JWT | Infos utilisateur connecté |
| POST | `/api/auth/logout` | — | Déconnexion (supprime cookie) |

**Register body :** `{ "email", "password", "name" }`
**Login body :** `{ "email", "password" }`

#### Notes (`/api/notes`)

| Méthode | Route | Auth | Description |
|---------|-------|------|-------------|
| GET | `/api/notes` | JWT | Toutes les notes non supprimées |
| GET | `/api/notes/deleted` | JWT | Notes dans la corbeille |
| POST | `/api/notes` | JWT | Créer une note |
| PUT | `/api/notes/:id` | JWT | Modifier une note |
| DELETE | `/api/notes/:id` | JWT | Soft-delete (corbeille) |
| POST | `/api/notes/:id/restore` | JWT | Restaurer depuis la corbeille |

**Note body :** `{ "title", "content", "folder" }`

#### Dossiers (`/api/folders`)

| Méthode | Route | Auth | Description |
|---------|-------|------|-------------|
| GET | `/api/folders` | JWT | Dossiers par défaut + personnalisés |
| POST | `/api/folders` | JWT | Créer un dossier |

**Dossiers par défaut :** Tout (📁), Travail (💼), Perso (🏠), Idées (💡)

#### Root

| Méthode | Route | Auth | Description |
|---------|-------|------|-------------|
| GET | `/` | — | `{"message": "📝 NathNotes API", "version": "1.0.0"}` |

---

## 10. Frontend NathNotes

### 10.1 nathnotes/index.html — Application de notes

Application de notes style Apple Notes avec :
- **Trois panneaux** : navigation dossiers, liste des notes, éditeur de note
- **Dark/Light mode** : bascule de thème
- **Recherche** de notes
- **Favoris** et corbeille
- **Dossiers personnalisés** avec icônes et couleurs
- **Purification HTML** avec DOMPurify pour la sécurité

**Authentification :** cookie httpOnly `token` géré automatiquement par le navigateur.

### 10.2 nathnotes/help.html — Guide d'utilisation

Page de documentation complète pour NathNotes.

---

## 11. Backend NathChat — Messagerie temps réel (port 3002)

### 11.1 server.js — Le serveur NathChat

`server.js` est le fichier principal de NathChat. Il combine un serveur Express et un serveur WebSocket.

**Fonctionnalités :**
1. API REST pour les salons et messages (protégée par JWT)
2. Serveur WebSocket pour la messagerie temps réel
3. Base de données sql.js (`nathchat.db`) avec salons, messages, membres et réactions
4. Salons par défaut : général, random, nathbank

**Les 4 tables créées automatiquement :**

```sql
rooms          -- Salons de discussion (name, type, created_at)
messages       -- Messages (room_id, user_id, username, content, created_at)
room_members   -- Membres des salons (room_id, user_id)
reactions      -- Réactions emoji sur les messages (message_id, user_id, emoji)
```

**Clé JWT :** `nathbank_secret_key` (même que NathBank)
**Authentification :** token JWT envoyé dans les messages WebSocket (`type: 'auth'`) ou header Authorization

### 11.2 Routes API NathChat

| Méthode | Route | Auth | Description |
|---------|-------|------|-------------|
| GET | `/api/rooms` | JWT | Liste tous les salons |
| GET | `/api/rooms/:id/messages` | JWT | Messages d'un salon avec réactions |
| POST | `/api/rooms` | JWT | Créer un nouveau salon |

### 11.3 Événements WebSocket

| Type | Description |
|------|-------------|
| `auth` | S'authentifier avec un token JWT |
| `join_room` | Rejoindre un salon et récupérer l'historique |
| `send_message` | Envoyer un message dans un salon |
| `react` | Ajouter/retirer une réaction emoji sur un message |
| `typing` | Indicator de frappe dans un salon |

**Événements reçus du serveur :** `auth_ok`, `rooms`, `room_history`, `new_message`, `reaction_update`, `user_typing`, `online_users`, `system`, `error`

---

## 12. Frontend NathProject (index.html à la racine)

Page de présentation du projet NathProject avec :
- Loader animé avec MacBook en CSS 3D
- Navigation vers NathBank, NathNotes, NathStore
- Hero section avec les 3 applications
- Cards des applications avec animations au survol
- Section statistiques animées (compteurs)
- Section langages avec barres de progression
- Timeline interactive (journal de dev)
- Récupération des commits GitHub en temps réel via l'API backend
- Design dark, verre dépoli, animations scroll reveal

**URL :** `http://127.0.0.1:5500/index.html`

---

## 13. Scripts utilitaires

### 13.1 seed.js — Remplir la BDD de produits

```bash
cd ~/projet-banque/banque
node seed.js
```

Ce script se connecte en tant qu'admin et insère automatiquement 20 produits répartis dans les 4 catégories de base (mode, tech, gaming, food).

### 13.2 clear-*.js — Nettoyer la BDD NathBank

Scripts situés dans `banque/` pour supprimer des données spécifiques :
- `clear-all.js` — Toutes les données
- `clear-users.js` — Utilisateurs
- `clear-produits.js` — Produits
- `clear-categories.js` — Catégories
- `clear-paniers.js` — Paniers
- `clear-commandes.js` — Commandes
- `clear-transactions.js` — Transactions

### 13.3 start.bat / start.ps1 — Lancement serveur Banque

Scripts dans `banque/` pour lancer le serveur sur Windows (CMD et PowerShell).

---

## 14. Comptes de test

| Type | Email | Mot de passe | Notes |
|------|-------|-------------|-------|
| Utilisateur NathBank | `nathanael@straumann.me` | `Nathlecon1234` | Solde initial 100€ |
| Admin NathStore | `nathanael@straumann.me` | `Nathlecon1234` | Accès panel admin |
| Utilisateur NathNotes | `nathanael@straumann.me` | `Nathlecon1234` | Token dans cookie httpOnly |

---

## 15. Clés secrètes JWT

| Type | Secret | Où utilisé |
|------|--------|-----------|
| Utilisateur NathBank | `mon_secret_jwt_super_secure_123` | `banque/middleware/auth.js` |
| Admin NathStore | `admin_secret_nathstore_456` | `banque/routes/admin.js`, `banque/routes/categories.js` |
| NathNotes | `nathnotes_secret_key_2026` | `nathnotes/server.js` |
| NathChat | `nathbank_secret_key` | `nathchat/server.js` |

---

## 16. Endpoints API rapide (NathBank)

| Méthode | Route | Auth |
|---------|-------|------|
| POST | `/api/auth/register` | — |
| POST | `/api/auth/login` | — |
| GET | `/api/comptes/solde` | JWT |
| POST | `/api/comptes/deposer` | JWT |
| POST | `/api/transactions/payer` | JWT |
| GET | `/api/transactions/historique` | JWT |
| GET | `/api/admin/produits` | — (public) |
| POST | `/api/admin/produits` | JWT admin |
| PUT | `/api/admin/produits/:id` | JWT admin |
| DELETE | `/api/admin/produits/:id` | JWT admin |
| GET | `/api/categories` | — (public) |
| POST | `/api/categories` | JWT admin |
| GET | `/api/panier` | JWT |
| POST | `/api/panier` | JWT |
| DELETE | `/api/panier` | JWT |
| GET | `/api/commandes` | JWT |
| POST | `/api/commandes` | JWT |
| GET | `/api/github-stats` | — |
| GET | `/api/github-commits` | — |

**Endpoints NathNotes (port 3001) :**
| Méthode | Route | Auth |
|---------|-------|------|
| POST | `/api/auth/register` | — |
| POST | `/api/auth/login` | — |
| GET | `/api/auth/me` | JWT cookie |
| POST | `/api/auth/logout` | — |
| GET | `/api/notes` | JWT cookie |
| POST | `/api/notes` | JWT cookie |
| PUT | `/api/notes/:id` | JWT cookie |
| DELETE | `/api/notes/:id` | JWT cookie |
| POST | `/api/notes/:id/restore` | JWT cookie |
| GET | `/api/folders` | JWT cookie |
| POST | `/api/folders` | JWT cookie |

**Endpoints NathChat (port 3002) :**
| Méthode | Route | Auth |
|---------|-------|------|
| GET | `/api/rooms` | JWT |
| GET | `/api/rooms/:id/messages` | JWT |
| POST | `/api/rooms` | JWT |

---

## 17. Configuration Live Server (important)

Dans `settings.json` de VS Code, ajouter :
```json
"liveServer.settings.ignoreFiles": ["**/*.db", "**/*.db-shm", "**/*.db-wal"]
```

Sans ça, chaque écriture en BDD recharge la page automatiquement.

---

## 18. Git — Sauvegarder et pousser le code

```bash
git add .                          # Préparer tous les fichiers modifiés
git commit -m "Description"        # Créer une sauvegarde locale
git push origin main               # Envoyer sur GitHub
```

Repo GitHub : `https://github.com/Nathlecon/prjbank`

Le `node_modules` et les fichiers `.db` sont ignorés via `.gitignore` — après un clone, faire `npm install` dans chaque dossier backend (`banque/`, `nathnotes/`, `nathchat/`).

---

## 19. Problèmes connus et solutions

| Problème | Cause | Solution |
|----------|-------|----------|
| Page qui recharge à chaque action | Live Server détecte les écritures SQLite | Ajouter `ignoreFiles` dans settings.json |
| `Cannot find module './routes/categories'` | Fichier manquant | Créer `banque/routes/categories.js` |
| Erreur sqlite3 sur Windows | Module compilé pour Mac | Utiliser sql.js à la place |
| Push Git rejeté | Historiques divergents | `git push origin main --force` |
| HTTP 400 sur push | Fichiers trop lourds (node_modules) | Ajouter `.gitignore` et `git rm -r --cached node_modules` |
| NathNotes ne démarre pas | Dépendances non installées | `cd nathnotes && npm install` |
| NathChat WebSocket ne connecte pas | Mauvaise URL ou port | Vérifier `ws://localhost:3002` |
| Cookie token non envoyé | CORS sans credentials | Configurer `credentials: true` dans CORS |

---

## 20. Architecture de communication

```
[NathStore frontend]   [NathBank frontend]   [NathNotes frontend]   [NathChat frontend]
        |                    |                      |                      |
        | fetch() HTTP       | fetch() HTTP         | fetch() HTTP +       | fetch() HTTP + WebSocket
        |                    |                      | cookie httpOnly      | (ws://localhost:3002)
        |                    |                      |                      |
        v                    v                      v                      v
[NathBank Backend - port 3000] [NathNotes Backend - port 3001] [NathChat Backend - port 3002]
        |                                |                                |
        | sql.js                         | sql.js                       | sql.js
        |                                |                                |
        v                                v                                v
[banque.db - SQLite]              [nathnotes.db - SQLite]         [nathchat.db - SQLite]
```

**Flux d'un achat sur NathStore :**
1. Utilisateur clique "+" → vérifie si connecté
2. Si non connecté → modal login → `POST /api/auth/login`
3. Token JWT stocké dans `localStorage`
4. Panier chargé depuis `GET /api/panier`
5. Modifications du panier → `POST /api/panier` (sauvegarde auto)
6. Clic "Payer" → `POST /api/transactions/payer` (débite le compte)
7. Succès → `POST /api/commandes` (enregistre la commande)
8. Panier vidé, confirmation affichée

---

© 2026 Nathanaël — Projet SNT · Bac Pro CIEL · KernelAndCo
