# 🔐 Identifiants d'accès — NathBank & NathStore

> **Attention :** Ces identifiants sont pour usage local en développement. Ne les partagez jamais en production.

---

## 🧑 Utilisateur NathBank (client)

| Champ | Valeur |
|-------|--------|
| **Email** | `nathanael@straumann.me` |
| **Mot de passe** | `Nathlecon1234` |
| **Solde de départ** | 100€ |

### Créer un compte
- Ouvrir `banque-frontend/index.html` → onglet "Créer un compte"
- Ou appeler `POST /api/auth/register` avec `{ nom, email, mot_de_passe }`

---

## 👑 Admin NathStore (gestion produits)

| Champ | Valeur |
|-------|--------|
| **Email** | `nathanael@straumann.me` |
| **Mot de passe** | `Nathlecon1234` |
| **Token stocké dans** | `localStorage.adminToken` |

---

## 📝 NathNotes (notes)

| Champ | Valeur |
|-------|--------|
| **Email** | `nathanael@straumann.me` |
| **Mot de passe** | `Nathlecon1234` |
| **Nom** | `Nathanael` |
| **Token stocké dans** | cookie `token` (httpOnly) |

### Créer un compte
```bash
curl -X POST http://localhost:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"nathanael@straumann.me","password":"Nathlecon1234","name":"Nathanael"}'
```

### Se connecter
```bash
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"nathanael@straumann.me","password":"Nathlecon1234"}'
```

---

## 🔑 Clés secrètes JWT

| Type | Secret | Où utilisé |
|------|--------|-----------|
| **Utilisateur** | `mon_secret_jwt_super_secure_123` | `auth.js`, `middleware/auth.js` |
| **Admin** | `admin_secret_nathstore_456` | `routes/admin.js`, `routes/categories.js` |

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
| `.env` | `banque/.env` | `GITHUB_TOKEN=...` pour les stats GitHub |
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

# 3. VS Code Live Server sur prjbank-main (port 5500)
```

**URLs :**
- NathBank : `http://127.0.0.1:5500/banque-frontend`
- NathStore : `http://127.0.0.1:5500/nathstore`
- Admin : `http://127.0.0.1:5500/nathstore/admin.html`
- NathNotes : `http://127.0.0.1:5500/nathnotes`
- API Banque : `http://localhost:3000`
- API Notes : `http://localhost:3001`