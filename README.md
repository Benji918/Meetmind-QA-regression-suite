# MeetMind QA Regression Suite

> AI-Powered Interview Platform — Full API Regression & Automation Suite

---

## Table of Contents

- [Project Overview](#project-overview)
- [Prerequisites](#prerequisites)
- [Repository Structure](#repository-structure)
- [Setup & Installation](#setup--installation)
- [Environment Configuration](#environment-configuration)
- [Running the Tests](#running-the-tests)
- [Understanding the Output](#understanding-the-output)
- [Postman Collection](#postman-collection)
- [API Flow Coverage](#api-flow-coverage)
- [Bug Reporting](#bug-reporting)
- [Troubleshooting](#troubleshooting)

---

## Project Overview

This repository contains the complete regression test suite for the **MeetMind** platform — an AI-powered interview system that handles candidate interviews, real-time transcription, and intelligent evaluation.

The suite covers:
- Authentication flows (Signup → Login → Token refresh → Logout)
- Interview session management (Create → Start → Submit → Evaluate)
- Candidate management flows
- Token chaining and session persistence
- End-to-end MVP validation across all milestones

**Postman Collection:** [View Online](https://documenter.getpostman.com/view/22927993/2sBXwnusXm#d36a7994-7933-4f74-a9b3-f7f7941da16f)

---

## Prerequisites

Before running any tests, make sure you have the following installed on your machine:

| Tool | Version | Purpose |
|------|---------|---------|
| Node.js | v16 or higher | Required to run Newman |
| Newman | Latest | CLI test runner for Postman |
| npm | v8 or higher | Package manager |
| Git | Any | Clone the repository |

### Check if Node.js is installed
```bash
node --version
```

### Check if npm is installed
```bash
npm --version
```

If Node.js is not installed, download it from: https://nodejs.org

---

## Repository Structure

```
meetmind-qa-regression/
│
├── collections/
│   └── collection.json
│
├── environments/
│   └── environment.json
│
├── results/
│   └── report.json
│
├── run-tests.sh
└── README.md
```

---

## Setup & Installation

### Step 1 — Clone the Repository

```bash
git clone git@github.com:Benji918/Meetmind-QA-regression-suite.git
cd meetmind-qa-regression
```

### Step 2 — Install Newman Globally

```bash
npm install -g newman
```

Verify the installation was successful:
```bash
newman --version
```

### Step 3 — Install Newman HTML Reporter (Optional but Recommended)

This gives you a clean visual HTML report in addition to the CLI output:

```bash
npm install -g newman-reporter-htmlextra
```

---

## Environment Configuration

The environment file holds all the variables used across the test suite. Most values are filled automatically by the test scripts during chained request flows, but the base URL must be set before running.

### Step 1 — Open the Environment File

Open `environments/environment.json` in any text editor.

### Step 2 — Set the Base URL

```json
{
  "name": "MeetMind Staging",
  "values": [
    {
      "key": "baseUrl",
      "value": "https://your-api-base-url.com",
      "enabled": true
    },
    {
      "key": "access_token",
      "value": "",
      "enabled": true
    },
    {
      "key": "refresh_token",
      "value": "",
      "enabled": true
    },
    {
      "key": "userId",
      "value": "",
      "enabled": true
    }
  ]
}
```

> **Note:** `access_token`, `refresh_token`, and `userId` should be left empty. They are automatically populated at runtime as the Login request runs and chains into subsequent requests.

### Step 3 — Export from Postman (If Updating the Collection)

If you make changes in Postman and need to re-export:

**Collection:**
1. Open Postman → Collections
2. Click the three dots (**...**) next to **MeetMind Regression Suite**
3. Click **Export** → Select **Collection v2.1**
4. Save to `collections/collection.json`

**Environment:**
1. Open Postman → Environments
2. Click the three dots (**...**) next to your environment
3. Click **Export**
4. Save to `environments/environment.json`

---

## Running the Tests

### Option 1 — Single Entry Point Script (Recommended)

**Mac / Linux:**
```bash
chmod +x run-tests.sh
./run-tests.sh
```

**Windows (PowerShell):**
```powershell
newman run collections/collection.json `
  --environment environments/environment.json `
  --reporters cli,json `
  --reporter-json-export results/report.json
```

---

### Option 2 — Run Directly with Newman (CLI)

**Basic run with CLI output:**
```bash
newman run collections/collection.json \
  --environment environments/environment.json \
  --reporters cli,json \
  --reporter-json-export results/report.json
```

**Run with HTML report (if newman-reporter-htmlextra is installed):**
```bash
newman run collections/collection.json \
  --environment environments/environment.json \
  --reporters cli,htmlextra,json \
  --reporter-htmlextra-export results/report.html \
  --reporter-json-export results/report.json
```

**Run a specific folder only (e.g., just Auth tests):**
```bash
newman run collections/collection.json \
  --environment environments/environment.json \
  --folder "Authentication" \
  --reporters cli
```

---

### Contents of `run-tests.sh`

```bash
#!/bin/bash

echo "============================================"
echo "  MeetMind QA — Regression Suite Runner"
echo "============================================"

# Create results directory if it doesn't exist
mkdir -p results

# Run the full regression suite
newman run collections/collection.json \
  --environment environments/environment.json \
  --reporters cli,json \
  --reporter-json-export results/report.json \
  --delay-request 200

echo ""
echo "============================================"
echo "  Test run complete. Report saved to:"
echo "  results/report.json"
echo "============================================"
```

---

## Understanding the Output

When Newman runs, you will see output like this in your terminal:

```
MeetMind Regression Suite

→ POST Login
  ✓  Status code is 200 OK
  ✓  Response time is less than 5000ms
  ✓  Access token stored in environment
  ✓  JWT format is valid

→ GET User Profile
  ✓  Status code is 200 OK
  ✓  User ID matches authenticated user

→ POST Create Interview Session
  ✗  Status code is 201 Created   (received 500)

┌─────────────────────────────┬──────────────┬──────────────┐
│                             │    executed  │    failed    │
├─────────────────────────────┼──────────────┼──────────────┤
│         iterations          │          1   │          0   │
│           requests          │         18   │          1   │
│       test-scripts          │         54   │          0   │
│      prerequest-scripts     │          6   │          0   │
│              assertions     │         54   │          1   │
├─────────────────────────────┴──────────────┴──────────────┤
│ total run duration: 4.5s                                   │
└────────────────────────────────────────────────────────────┘
```

**What each symbol means:**

| Symbol | Meaning |
|--------|---------|
| `✓` | Test passed |
| `✗` | Test failed — log this as a bug |
| `→` | Request was executed |

> Any line marked with `✗` must be logged in the Bug Report document immediately.

---

## Postman Collection

**Online Documentation:** [MeetMind Postman Collection](https://documenter.getpostman.com/view/22927993/2sBXwnusXm#d36a7994-7933-4f74-a9b3-f7f7941da16f)

### Chained Request Flows Covered

```
1. AUTH FLOW
   POST /signup
      ↓ (saves userId)
   POST /verify-email
      ↓
   POST /login
      ↓ (saves access_token, refresh_token)
   GET  /profile
      ↓
   POST /auth/refresh
      ↓ (updates access_token)
   POST /logout

2. INTERVIEW FLOW
   POST /interviews/create
      ↓ (saves interviewId)
   POST /interviews/{{interviewId}}/start
      ↓
   POST /interviews/{{interviewId}}/submit
      ↓
   GET  /interviews/{{interviewId}}/results
      ↓
   DELETE /interviews/{{interviewId}}

3. CANDIDATE FLOW
   POST /candidates
      ↓ (saves candidateId)
   GET  /candidates/{{candidateId}}
      ↓
   PUT  /candidates/{{candidateId}}
      ↓
   DELETE /candidates/{{candidateId}}

   

