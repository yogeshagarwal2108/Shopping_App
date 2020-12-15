import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../provider/product.dart';
import '../provider/provider_products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode= FocusNode();
  final _descriptionFocusNode= FocusNode();
  final _imageUrlFocusNode= FocusNode();
  final _imageUrlController= TextEditingController();
  var editingProduct= Product(id: null, title: "", price: 0.0, description: "", imageUrl: "");
  var _initValues= {
    "title": "",
    "price": "",
    "description": "",
    "imageUrl": "",
  };
  final _formKey= GlobalKey<FormState>();
  bool isLoading= false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  var _isInit= true;

  @override
  void didChangeDependencies() {
    if(_isInit){
      String productId= ModalRoute.of(context).settings.arguments as String;
      if(productId!= null){
        editingProduct= Provider.of<ProviderProducts>(context, listen: false).findById(productId);
        _initValues= {
          "title": editingProduct.title,
          "price": editingProduct.price.toString(),
          "description": editingProduct.description,
          "imageUrl": "",
        };
        _imageUrlController.text= editingProduct.imageUrl;
      }
    }
    _isInit= false;
    super.didChangeDependencies();
  }

  @override
  void dispose(){
    _imageUrlFocusNode.removeListener(updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus){
      if((!_imageUrlController.text.startsWith("http") && !_imageUrlController.text.startsWith("https")) ||
          (!_imageUrlController.text.endsWith(".png") && !_imageUrlController.text.endsWith(".jpg") && !_imageUrlController.text.endsWith(".jpeg")))
      {
        return;
      }

      setState(() {});
    }
  }

  saveForm() async{
    final isValid = _formKey.currentState.validate();
    if(isValid){
      _formKey.currentState.save();
      if(editingProduct.id== null){
        try{
          setState(() {
            isLoading= true;
          });
          await Provider.of<ProviderProducts>(context, listen: false).addProducts(editingProduct);
        }catch(error){
          await showDialog(
            context: context,
            builder: (context)=> AlertDialog(
              title: Text("An error occurred!"),
              content: Text("Something went wrong"),
              elevation: 5,
              actions: <Widget>[
                FlatButton(
                  child: Text("Okay"),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      }
      else{
        setState(() {
          isLoading= true;
        });
        await Provider.of<ProviderProducts>(context, listen: false).updateProducts(editingProduct.id, editingProduct);
      }

      setState(() {
        isLoading= false;
      });
      Navigator.of(context).pop();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: (){
              saveForm();
            },
          )
        ],
      ),

      body: isLoading ? Center(child: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor,)) : Padding(
        padding: EdgeInsets.all(10),

        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    initialValue: _initValues["title"],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(style: BorderStyle.solid),
                      ),
                      labelText: "Title",
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (val){
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    validator: (value){
                      if(value.isEmpty){
                        return "Please provide title.";
                      }
                      return null;
                    },
                    onSaved: (value){
                      editingProduct= Product(
                        id: editingProduct.id,
                        title: value,
                        price: editingProduct.price,
                        description: editingProduct.description,
                        imageUrl: editingProduct.imageUrl,
                        isFavourite: editingProduct.isFavourite,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    initialValue: _initValues["price"],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(style: BorderStyle.solid),
                      ),
                      labelText: "Price",
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (val){
                      FocusScope.of(context).requestFocus(_descriptionFocusNode);
                    },
                    validator: (value){
                      if(value.isEmpty){
                        return "Please provide price";
                      }
                      if(double.parse(value)<=0){
                        return "Please enter a number greater than zero.";
                      }
                      if(double.tryParse(value)== null){
                        return "Please provide valid price.";
                      }
                      return null;
                    },
                    onSaved: (value){
                      editingProduct= Product(
                        id: editingProduct.id,
                        title: editingProduct.title,
                        price: double.parse(value),
                        description: editingProduct.description,
                        imageUrl: editingProduct.imageUrl,
                        isFavourite: editingProduct.isFavourite,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    initialValue: _initValues["description"],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(style: BorderStyle.solid),
                      ),
                      labelText: "Description",
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    focusNode: _descriptionFocusNode,
                    validator: (value){
                      if(value.isEmpty){
                        return "Please provide description.";
                      }
                      if(value.length<10){
                        return "Description should be at least 10 characters long.";
                      }
                      return null;
                    },
                    onSaved: (value){
                      editingProduct= Product(
                        id: editingProduct.id,
                        title: editingProduct.title,
                        price: editingProduct.price,
                        description: value,
                        imageUrl: editingProduct.imageUrl,
                        isFavourite: editingProduct.isFavourite,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        margin: EdgeInsets.only(top: 5, right: 7),
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, width: 1.0),
                        ),
                        child: _imageUrlController.text.isEmpty ? Text("No image Url") : FittedBox(
                          child: Image.network(_imageUrlController.text),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(style: BorderStyle.solid),
                            ),
                            labelText: "Image Url",
                          ),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          validator: (value){
                            if(value.isEmpty){
                              return "Please provide Image Url";
                            }
                            if(!value.startsWith("http") && !value.startsWith("https")){
                              return "Please enter valid url";
                            }
                            if(!value.endsWith(".png") && !value.endsWith(".jpg") && !value.endsWith(".jpeg")){
                              return "Please provide valid url";
                            }
                            return  null;
                          },
                          onSaved: (value){
                            editingProduct= Product(
                              id: editingProduct.id,
                              title: editingProduct.title,
                              price: editingProduct.price,
                              description: editingProduct.description,
                              imageUrl: value,
                              isFavourite: editingProduct.isFavourite,
                            );
                          },
                          onFieldSubmitted: (val){
                            saveForm  ();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
