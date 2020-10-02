#!/usr/bin/python
from flask import Flask, request, jsonify, render_template
from flask_restful import abort, Api, Resource
from flask_jwt_extended import JWTManager, jwt_optional, create_access_token, get_jwt_identity, get_raw_jwt
import json

app = Flask(__name__)
app.config['PROPAGATE_EXCEPTIONS'] = True
app.config['JSON_AS_ASCII'] = False
app.config['JSONIFY_PRETTYPRINT_REGULAR'] = True
app.config["JSON_SORT_KEYS"] = False
#app.config['JWT_TOKEN_LOCATION'] = ['query_string']
app.config['JWT_SECRET_KEY'] = 'super-secret'
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = False
app.config['JWT_REFRESH_TOKEN_EXPIRES'] = False
jwt = JWTManager(app)
flag = "{% FLAG %}"

with open('/etc/opt/hab-services.json') as data: services = json.loads(data.read())
with open('/etc/opt/hab-customers.json') as data: customers = json.loads(data.read())
with open('/etc/opt/hab-users.json') as data: employees = json.loads(data.read())
for key in employees: del employees[key]['password']

def msg():
	raw_jwt = get_raw_jwt()
	if raw_jwt and raw_jwt['jti'] == 'f8097f0d-eb3b-4a92-b0af-c04933dc5152':
		msg = "We should probably should have revoked this token, or at least expired it ... " + flag
	elif get_jwt_identity() == "admin":
		msg = "Huh? How? Our private key is super-secret! " + flag
	else:
		msg = None
	return msg

class getResource(Resource):
	@jwt_optional
	def get(self):
		if request.path == "/endpoints":
			data = {"services":{"method":"GET","auth":False,"subresource":"service_id"},"employees":{"method":"GET","auth":"guest","subresource":"employee_id"},"customers":{"method":"GET","auth":"admin","subresource":"customer_id"},"login":{"method":"POST","auth":False,"subresource":False},"endpoints":{"method":"GET","auth":False,"subresource":False}}
		elif request.path == "/services":
			data = services.keys()
		elif request.path == "/employees":
			if not get_jwt_identity():
				abort(401, msg="Requires authentication")
			data = employees.keys()
		elif request.path == "/customers":
			if not get_jwt_identity() == "admin":
				abort(403, msg="Insufficient Privileges")
			data = customers.keys()

		meta = {"auth": get_jwt_identity(), "total": len(data), "msg": msg()}

		return jsonify({"_meta":meta,"items":data})

class getSubResource(Resource):
	@jwt_optional
	def get(self, name):
		if "/services" in request.path:
			data = services
		elif "/employees" in request.path:
			if not get_jwt_identity():
				abort(401, msg="Requires authentication")
			data = employees
		elif "/customers" in request.path:
			if not get_jwt_identity() == "admin":
				abort(403, msg="Insufficient Privileges")
			data = customers

		if name not in data:
			abort(404, msg="Resource not found")

		meta = {"auth": get_jwt_identity(), "total": len(data[name]), "msg": msg()}

		return jsonify({"_meta":meta,"items":data[name]})

@app.route('/')
def index():
	return render_template('index.html')

@app.route('/login', methods=['POST'])
def login():
	if not request.is_json:
		return jsonify({"msg": "Missing JSON in request"}), 400
	username = request.json.get('username', None)
	password = request.json.get('password', None)
	if not username or not password:
		return jsonify({"msg": "Missing username and/or password parameter(s)"}), 400

	if username == 'guest' and password == 'guest':
		access_token = create_access_token(identity=username)
		return jsonify(access_token=access_token), 200
	else:
		return jsonify({"msg": "Bad username or password"}), 401

api = Api(app, request, catch_all_404s=True)
api.add_resource(getResource, '/services', '/employees', '/customers', '/endpoints')
api.add_resource(getSubResource, '/services/<name>', '/employees/<name>', '/customers/<name>')
