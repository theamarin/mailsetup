# mailsetup
Scripts to setup a mail server with dovecot, postfix and rspamd under Debian 10 (Buster)

# German version
(Please find an English version below)

## Einleitung
Dieses Repository beinhaltet einige Skripte, die das Aufsetzen eines Mail-Servers mit Dovecot, Postfix, rspamd und mysql (bzw. mariadb) unter Debian 10 ("Buster") weitgehend automatisieren.
Die verwendete Konfiguration basiert auf dem hervorragenden Blog-Eintrag von Thomas Leister:
https://thomas-leister.de/mailserver-debian-stretch/ .
Dort sind viele der Optionen gut erklärt und begründet.
Es bietet sich an, zum Verständnis der Konfiguration den Blog-Eintrag komplett zu lesen.

## Voraussetzungen
Es wird davon ausgegangen, dass auf der lokalen Maschine ein SSH-Key vorliegt, mit dem man sich ohne Passwort auf dem aufzusetzenden Mail-Server einloggen kann.
Das kann z.B. durch einen Eintrag in `~/.ssh/config` erreicht werden:
```Host <Mail-Server-Alias>
	HostName <IP-Adresse oder Hostname des Servers>
	User root
	IdentityFile ~/.ssh/<mykey>.id_rsa
```
Erzeugt werden kann ein solcher Key mit `ssh-keygen`.
Bei weiteren Fragen hilft zunächst jede Suchmaschine.

## Konfiguration
Als nächstes ist eine Konfigurationsdatei `mail/inc.config.sh` zu erstellen.
Dort wird hauptsächlich die zu bedienende Domain angepasst und ein Passwort für die mysql-Datenbank gewählt.
Als Vorlage kann dazu `mail/inc.config.example` dienen.
Die fertige Konfigurationsdatei enthält entsprechend beispielsweise das mysql-Passwort und sollte nicht in ein öffentliches Repository eingecheckt werden.
Daher ist diese Datei in `.gitignore` eingetragen.

## Los gehts!
Der Mailserver kann als Einzeiler durch Aufruf von `./setup.sh mail` aufgesetzt werden.
Wer lieber etwas mehr Kontrolle hat, kann die Skripte einzeln ausführen:
```
   ./setup.sh mail/0-basic
   ./setup.sh mail/1-unbound
   ...
```
Die Skripte sind so ausgelegt, dass sie mehrfach aufgerufen werden können.

Anschließend muss nur noch die Datenbank gefüllt, also die Benutzer eingerichtet werden.

## DNS
Was die Skripte derzeit nicht leisten (können), ist das Einrichten der benötigten DNS-Einträge.
Dazu verweise ich nochmal auf den Blog-Eintrag und zusätzlich auf die Ausgabe des Skriptes `./setup.sh mail/6-rspamd`.


# English version
(Die deutsche Einleitung ist weiter oben zu finden.)


## Introduction
This repository contains several scripts that aim to simplify the setup of a mail server with Dovecot, Postfix, rspamd and mysql (or rather mariadb) on Debian 10 "Buster".
The configuration that is setup by the scripts is based on the outstanding blog post by Thomas Leister:
https://thomas-leister.de/en/mailserver-debian-stretch/ .
You will find motivation and explanations for most of the options there.
I encourage to read the whole blog entry to fully understand what happens.

## Prerequisities
The scripts assume that you have an SSH key on your local machine that allows root access to the prospective remote mail server (without any passphrase).
You might want to adapt your `~/.ssh/config` to accomplish this:
```Host <mail server alias>
	HostName <IP address or host name of the server>
	User root
	IdentityFile ~/.ssh/<mykey>.id_rsa
```
You can generate such keys using `ssh-keygen`.
Please contact your web search engine for further questions.

## Configuration
You need to create a config file `mail/inc.config.sh` to specify the mail domain and a mysql database password.
You may copy the example file `cp mail/inc.config.example mail/inc.config.sh` and adapt it.
Your adapted configuration file will contain a password and should not be added to a public repository!
This is why this file is listed in `.gitignore`.

## Let's setup!
The prospective mail server can be setup by just calling `./setup.sh mail`.
If you prefer to do it step by step, go ahead and call the scripts one by one:
```
   ./setup.sh mail/0-basic
   ./setup.sh mail/1-unbound
   ...
   ./setup.sh mail/6-rspamd
```
The scripts are designed such that they can be safely called multiple times.

Finally, you will have to fill up the user database.

## DNS
The scripts (currently) cannot setup the required DNS entries.
Please refer to the above-mentioned blog post and to the output of the script `./setup.sh mail/6-rspamd`.
