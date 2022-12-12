from flask import Flask, jsonify
import json


app = Flask(__name__)

api = [{"id": 1,
        "med": "Crosin",
        "use": {
        "info": "to give releaf from body pain",
        "disease":"body pain"
        },
        },

       {"id": 2,
        "med": "Royal Red",
        "use": {
        "info": "to give releaf from body pain",
        "disease":"body pain"
        },
        },

       {"id": 3,
        "med": "Dolonex",
        "use": {
        "info": "to give releaf from body pain",
        "disease":"body pain"
        },
        },

       {"id": 4,
        "med": "Pacimol",
        "use": {
        "info": "to give releaf from body pain",
        "disease":"body pain"
        },
        },

       {"id": 5,
        "med": "Aspirin",
        "use": {
        "info": "Used in fever",
        "disease":"fever"
        },
        },


       {"id": 6,
        "med": "Docosanol",
        "use": {
        "info": "Used in fever",
        "disease":"fever"
        },
        },


       {"id": 7,
        "med": "Ketoprofen",
        "use": {
        "info": "Used in fever",
        "disease":"fever"
        },
        },

       {"id": 8,
        "med": "Antacid",
        "use": {
        "info": "Used to reduse the acidity",
        "disease":"acidity"
        },
        },


       {"id": 9,
        "med": "Gaviscon",
        "use": {
        "info": "Used to reduse the acidity",
        "disease":"acidity"
        },
        },


       {"id": 10,
        "med": "Maalox",
        "use": {
        "info": "Used to reduse the acidity",
        "disease":"acidity"
        },
        },


       {"id": 11,
        "med": "Alamag",
        "use": {
        "info": "Used to reduse the acidity",
        "disease":"acidity"
        },
        },


       {"id": 12,
        "med": "Ciclopirox",
        "use": {
        "info": "Used for sleep disorder",
        "disease":"sleep disorder",
        },
        },


       {"id": 13,
        "med": "Doxepin",
        "use": {
        "info": "Used for sleep disorder",
        "disease":"sleep disorder",
        }
        },


       {"id": 14,
        "med": "Doxylamin",
        "use": {
        "info": "Used for sleep disorder",
        "disease":"sleep disorder",
        },
        },


       {"id": 15,
        "med": "Trastuzumab",
        "use": {
        "info": "Used in cancer treatment",
        "disease":"cancer"
        },
        },


       {"id": 16,
        "med": "Nivolumab",
        "use": {
        "info": "Used in cancer treatment",
        "disease":"cancer",
        },
        },

       ]


@app.route('/api/')
def med():
    return api


# to get diseases (parameter : med)
@app.route("/api/med/<s>/")
def med_name(s):
    # s = list(s.split(','))
    for i in range(len(api)):
        if api[i]["med"] == s:
            return jsonify({'aid':api[i]["use"]["disease"] })

# to get alternative med (parameter: disease name)
@app.route("/api/med/disease/<s>")
def alternative(s):
    # s = list(s.split(','))
    for i in range(len(api)):
        if api[i]["use"]["disease"] == s:
            return [(api[i]["med"]) for i in range(len(api)) if api[i]["use"]["disease"] == s]

# to get med (parameter : disease)
@app.route("/api/med/detect/<s>")
def detect(s):
    med = []
    s = list(s.split(','))
    print(s)
    for i in range(len(api)):
        for j in range(len(s)):
            if api[i]["med"] == (s[j]):
                med.append((s[j]))
    # print(med)
    return jsonify({'medicines':med})


if __name__ == '__main__':
    app.run(debug=True)
