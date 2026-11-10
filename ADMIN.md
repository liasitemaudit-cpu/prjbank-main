# 🔐 Identifiants d'accès — NathBank & NathStore

> **Attention :** Ces identifiants sont pour usage local en développement. Ne les partagez jamais en production. Les valeurs réelles des mots de passe et clés secrètes sont stockées dans `.env` (fichier ignoré par Git, non versionné).

---

## 🧑 Utilisateur NathBank (client)

| Champ | Valeur |
|-------|--------|
| **Email** | `nathanael@straumann.me` |
| **Mot de passe** | (voir `.env` / compte créé à l'inscription) |
| **Solde de départ** | 100€ |

### Créer un compte
- Ouvrir `banque-frontend/index.html` → onglet "Créer un compte"
- Ou appeler `POST /api/auth/register` avec `{ nom, email, mot_de_passe }`

---

## 👑 Admin NathStore (gestion produits)

| Champ | Valeur |
|-------|--------|
| **Email** | (compte admin créé via `/api/admin/setup`) |
| **Mot de passe** | (défini lors de la création du compte admin) |
| **Token stocké dans** | `localStorage.adminToken` |

### Créer le premier compte admin
Appeler `POST /api/admin/setup` avec `{ email, mot_de_passe, secret: 'NATHSTORE_ADMIN_2026' }`.

---

## 📝 NathNotes (notes)

| Champ | Valeur |
|-------|--------|
| **Email** | (compte créé à l'inscription) |
| **Mot de passe** | (défini lors de l'inscription) |
| **Token stocké dans** | cookie `token` (httpOnly) |

---

## 🔑 Clés secrètes JWT

Les secrets sont définis dans `.env` (non versionné) :
- `JWT_SECRET` — utilisé par `auth.js` et `middleware/auth.js`
- `JWT_SECRET_ADMIN` — utilisé par `routes/admin.js` et `routes/categories.js`

Valeurs par défaut (développement uniquement) définies dans `.env`.

---

## 🔌 Endpoints API rapide

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
| GET | `/api/commandes` | JWT |
| POST | `/api/commandes` | JWT |

---

## 📁 Fichiers de configuration

| Fichier | Chemin | Utilité |
|---------|--------|---------|
| `.env` | `banque/.env` | `GITHUB_TOKEN`, `JWT_SECRET`, `JWT_SECRET_ADMIN` |
| `start-all.bat` | racine | Lance tout (serveurs + navigateurs) |
| `banque/start.bat` | `banque/` | Lance le serveur Banque |
| `banque/start.ps1` | `banque/` | Lance le serveur Banque (PowerShell) |

---

## 🚀 Lancer le projet

```bash
# Depuis la racine
start-all.bat

# Ou manuellement :
# 1. Serveur Banque (port 3000)
cd banque && node index.js

# 2. Serveur NathNotes (port 3001)
cd nathnotes && node server.js

# 3. Serveur NathChat (port 3002)
cd nathchat && node server.js

# 4. VS Code Live Server sur le port 5500
```

**URLs :**
- NathBank : `http://127.0.0.1:5500/banque-frontend`
- NathStore : `http://127.0.0.1:5500/nathstore`
- Admin : `http://127.0.0.1:5500/nathstore/admin.html`
- NathNotes : `http://127.0.0.1:5500/nathnotes`
- NathChat : `http://127.0.0.1:5500/nathchat`
- API Banque : `http://localhost:3000`
- API Notes : `http://localhost:3001`
- API Chat : `http://localhost:3002`

---

## 📋 Procédure seed (produits de démo)

1. Créer le premier compte admin via `POST /api/admin/setup` (clé secrète : `NATHSTORE_ADMIN_2026`).
2. Lancer le serveur Banque (`cd banque && node index.js`).
3. Exécuter le seed : `cd banque && node seed.js`.
4. Les 20 produits de démo sont insérés dans la base.

---

## ⚠️ Sécurité

Ce projet est développé dans un contexte éducatif (Bac Pro CIEL / SNT) pour un usage local uniquement. Les secrets, mots de passe et tokens ne doivent jamais être commités ni versionnés. Le fichier `.env` est ignoré par Git via `.gitignore`.