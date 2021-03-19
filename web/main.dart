import 'dart:convert';
// import 'dart:io' hide HttpRequest;
import 'dart:html'
    show DivElement, HttpRequest, LIElement, UListElement, querySelector;
import 'dart:html';
// import 'dart:io';
import 'package:mustache_template/mustache_template.dart';

/*
 {quoteText: To lead people walk behind them.  , 
 quoteAuthor: Lao Tzu , 
 senderName: , 
 senderLink: , 
 quoteLink: http://forismatic.com/en/39a355e852/}
*/

var quote;

class Quote {
  String quoteText;
  String senderName;
  String senderLink;
  String quoteLink;
  Quote.fromJson(Map json) {
    this.quoteText = json['quoteText'];
    this.senderName = json['senderName'];
    this.senderLink = json['senderLink'];
    this.quoteLink = json['quoteLink'];
  }
}

/*Future<void> makeRequest(/*Event _*/) async {
  const path = 'https://dart.dev/f/portmanteaux.json';
  try {
    // Make the GET request
    final jsonString = await HttpRequest.getString(path);
    print(json.decode(jsonString));
    // The request succeeded. Process the JSON.
    // processResponse(jsonString);
  } catch (e) {
    // The GET request failed. Handle the error.
    print('Couldn\'t open $path');
    // wordList.children.add(LIElement()..text = 'Request failed.');
  }
}*/

/*
 *  POST:
method=getQuote&key=457653&format=xml&lang=en
 */
Future<Quote> makeRequest(/*Event _*/) async {
  var queryParameters = {
    'method': 'getQuote',
    'key': '457653',
    'format': 'json',
    'lang': 'en'
  };
  const path = 'http://dart.localnet:3010/api/';
  // final httpRequest = HttpRequest();
  /*await Future.value(httpRequest
    ..open('GET', path)
    ..onLoadEnd.listen((e) => requestComplete(httpRequest))
    ..send(queryParameters));*/
  await HttpRequest.postFormData(path, queryParameters)
      .then((HttpRequest resp) {
    print(Quote.fromJson(json.decode(resp.responseText)).quoteText);
    quote = Quote.fromJson(json.decode(resp.responseText));
  });
  // final jsonData = await HttpRequest.getString(path);
  // requestCompleteSimple(jsonData);
  return quote;
}

/*void requestCompleteSimple(String jsonString) {
  print(json.decode(jsonString));
}*/

/*void requestComplete(HttpRequest request) {
  switch (request.status) {
    case 200:
      print(json.decode(
          request.responseText)); // processResponse(request.responseText);
      return;
    default:
      print(request
          .status); // final li = LIElement()..text = 'Request failed, status=${request.status}';
    // wordList.children.add(li);
  }
}*/

void buildCard(Quote data) {
  var card = DivElement();
  // var author = DivElement();
  // author.text = data.senderName;
  var quoteText = DivElement();
  quoteText.text = data.quoteText;
  // var quoteLink = DivElement();
  // quoteLink.text = data.quoteLink;
  // var senderLink = DivElement();
  // senderLink.text = data.senderLink;
  card.append(quoteText);
  querySelector('#card').children.add(card);
}

LIElement addTodoItem(String item) {
  print(item);
  return LIElement()..text = item;
}

Future<UListElement> thingsTodo() async {
  var todoList = UListElement();
  var actions = ['Walk', 'Wash', 'Feed'];
  var pets = ['cats', 'dogs'];

  for (var action in actions) {
    for (var pet in pets) {
      if (pet == 'cats' && action != 'Feed') {
        continue;
      } else {
        var todoItem = addTodoItem('Hi 🇩🇰 $action the $pet');
        todoList.children.add(todoItem);
      }
    }
  }
  return todoList;
}

Future<void> loadTodoList() async {
  var list = await thingsTodo();
  for (var item in list.children) {
    await Future.delayed(
        Duration(seconds: 2), () => querySelector('#output').append(item));
  }
}

templateSome() {
  var source = '''
	  {{# names }}
            <div>{{ lastname }}, {{ firstname }}</div>
	  {{/ names }}
	  {{^ names }}
	    <div>No names.</div>
	  {{/ names }}
	  {{! I am a comment. }}
	''';
  //var template;
  // FileReader fr = new FileReader();
  // var source = fr.readAsText();
  var template = Template(source, name: 'template-filename.html'); // });

  // TODO: load from our quote data
  var output = template.renderString({
    'names': [
      {'firstname': 'Greg', 'lastname': 'Lowe'},
      {'firstname': 'Bob', 'lastname': 'Johnson'}
    ]
  });

  // print(output);
  return output;
}

Future<void> main() async {
  await makeRequest().then((value) => buildCard(value));
  await loadTodoList();
  querySelector('#template').appendHtml(templateSome());
}
