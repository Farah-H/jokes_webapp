import os
from datetime import datetime

from flask import Flask, render_template, redirect, request
from flask_pymongo import PyMongo
from flask_wtf import FlaskForm
from wtforms import TextField, SubmitField
from wtforms.validators import DataRequired

# configure app
application = Flask(__name__)
application.config["MONGO_URI"] = f"mongodb://{os.environ['MONGODB_USERNAME']}:{os.environ['MONGODB_PASSWORD']}@{os.environ['MONGODB_HOSTNAME']}:27017/{os.environ['MONGODB_DATABASE']}"
application.config['SECRET_KEY'] = os.environ['SECRET_KEY']

mongo = PyMongo(application)
db = mongo.db


class JokeForm(FlaskForm):
    name = TextField('Name:', validators=[DataRequired()])
    joke = TextField('Please type your joke here:', validators=[DataRequired()])
    submit = SubmitField('Submit')


@application.route('/', methods=['GET', 'POST'])
def index():
    form = JokeForm(request.form)
    message = ""
    if request.method == "POST":
        name = form.name.data
        joke = form.joke.data
        date = datetime.utcnow()
        entry = {
            'name': name,
            'joke': joke,
            'date': date.strftime("%B %d %Y %H:%M")
        }

        db.jokes.insert_one(entry)

        form.name.data = ""
        form.joke.data = ""

        message = "Success! Please head over to the collection page to see your joke displayed."
    return render_template('index.html', form=form, message=message)

@application.route("/collection")
def collection():
    jokes = list(db.jokes.find({}))
    return render_template('collection.html', jokes=jokes)


if __name__ == "__main__":
    ENVIRONMENT_DEBUG = os.environ.get("APP_DEBUG", True)
    ENVIRONMENT_PORT = os.environ.get("APP_PORT", 5000)
    application.run(host='0.0.0.0', port=ENVIRONMENT_PORT, debug=ENVIRONMENT_DEBUG)