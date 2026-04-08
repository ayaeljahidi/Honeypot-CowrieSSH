# Cowrie Honeypot Lab (Fedora)

<p align="center">
  <img src="https://img.shields.io/badge/Cybersecurity-Honeypot-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/Tool-Cowrie-black?style=for-the-badge">
  <img src="https://img.shields.io/badge/Platform-Fedora-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/Logs-JSON-green?style=for-the-badge">
  <img src="https://img.shields.io/badge/Status-Active-success?style=for-the-badge">
</p>

---

## Overview

This project deploys a **Cowrie SSH/Telnet Honeypot on Fedora** to simulate real-world cyberattacks and capture attacker behavior in a controlled environment.

It provides:
- Real-time attack logging 
- Port redirection (22 → 2222) 
- Attack simulation using Kali Linux 
- JSON logs ready for AI/LLM analysis  

---

##  Why This Project?

Cyber attackers constantly scan and exploit SSH services.

This honeypot allows you to:
- Observe attacker techniques  
- Capture malicious commands  
- Analyze intrusion patterns  
- Build AI-based detection systems  

---

##  Architecture

<p align="center">
 Kali Linux (Attacker)
          │
          ▼
    SSH Port 22
          │
          ▼
 iptables Redirection
          │
          ▼
 Cowrie Honeypot (2222)  
          │
          ▼  
        Logs

</p>

---

##  Quick Setup

```bash
chmod +x setup_cowrie.sh
./setup_cowrie.sh
```

---
## Run the Honeypot
```bash
cd ~/cowrie
source cowrie-env/bin/activate
cowrie start
cowrie stop
```
##Port Redirection
```bash
sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222
```
##Logs & Monitoring
```bash
cd ~/cowrie/var/log/cowrie
tail -f cowrie.json
```
