import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/providers/products.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();

  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;

      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;
        _formData['price'] = product.price.toStringAsFixed(2);

        _imageUrlController.text = product.imageUrl;
      } else {
        _formData['price'] = '';
      }
    }
  }

  void _updateImageUrl() {
    bool isValid = this._form.currentState.validate();
    if (!isValid) {
      return;
    }
    setState(() {});
  }

  bool isImageUrlValid(String url) {
    bool isValidProtocol = url.toLowerCase().startsWith('http://') ||
        url.toLowerCase().startsWith('https://');

    bool endsWithPngJpgJpeg = url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg') ||
        url.toLowerCase().endsWith('.pgn');

    return isValidProtocol && endsWithPngJpgJpeg;
  }

  _saveForm() {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    final newProduct = Product(
      id: _formData['id'],
      title: _formData['title'],
      description: _formData['description'],
      price: _formData['price'],
      imageUrl: _formData['imageUrl'],
    );

    final _products = Provider.of<Products>(context, listen: false);

    if (_formData['id'] == null) {
      _products.addProduct(newProduct);
    } else {
      _products.updateProduct(newProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário Produto'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _formData['title'],
                decoration: InputDecoration(labelText: 'Título'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _formData['title'] = value;
                },
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Informe um título válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['price'].toString(),
                decoration: InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _formData['price'] = double.tryParse(value);
                },
                validator: (value) {
                  if (value.trim().isEmpty || !(double.parse(value) > 0)) {
                    return 'Informe um valor maior que 0';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['description'],
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _formData['description'] = value;
                },
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Informe uma descrição válida';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Url da imagem'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocusNode,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _formData['imageUrl'] = value;
                      },
                      validator: (value) {
                        if (!isImageUrlValid(value) || value.trim().isEmpty) {
                          return 'Por favor, informe uma URL válida';
                        }

                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informe a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
