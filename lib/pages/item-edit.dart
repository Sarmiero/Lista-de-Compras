import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:listas_de_compras/application.dart';
import 'package:listas_de_compras/layout.dart';
import 'package:listas_de_compras/utils/QuantityFormatter.dart';
import 'items.dart';

import 'package:listas_de_compras/models/Item.dart';

class ItemEditPage extends StatefulWidget {
  static String tag = 'page-item-edit';
  static Map item;

  @override
  _ItemEditPageState createState() => _ItemEditPageState();
}

class _ItemEditPageState extends State<ItemEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _cName = TextEditingController();
  final _cQtd = TextEditingController();
  final _cValor = MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: ',',
    leftSymbol: 'R\$ ',
  );

  final _qtdFocus = FocusNode();

  String selectedUnit;
  bool isSelected;

  @override
  void initState() {
    _cName.text = ItemEditPage.item['name'];
    _cQtd.text = ItemEditPage.item['quantidade'].toString();
    _cValor.text = ItemEditPage.item['valor'];
    this.isSelected = (ItemEditPage.item['checked'] == 1);

    unity.forEach((name, precision) {
      if (precision == ItemEditPage.item['precisao']) {
        this.selectedUnit = name;
      }
    });

    // Isso vai fazer com que sempre que
    // o campo de quantidade for selecionado
    // todo o campo fica selecionado automaticamente
    // assim o usuario nao precisa apagar o
    // conteudo para adicionar a nova quantidade
    _qtdFocus.addListener(() {
      _cQtd.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _cQtd.text.length,
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Instancia model
    ModelItem itemBo = ModelItem();

    final inputName = TextFormField(
      controller: _cName,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Nome do item',
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Obrigatório';
        }
        return null;
      },
    );

    final inputQuantidade = TextFormField(
      controller: _cQtd,
      autofocus: false,
      focusNode: _qtdFocus,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Quantidade',
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      inputFormatters: [
        new QuantityFormatter(precision: unity[this.selectedUnit])
      ],
      validator: (value) {
        double valueAsDouble = (double.tryParse(value) ?? 0.0);

        if (valueAsDouble <= 0) {
          return 'Informe um número positivo';
        }
        return null;
      },
    );

    final inputUnit = DropdownButton<String>(
      value: this.selectedUnit,
      onChanged: (String newValue) {
        setState(() {
          double valueAsDouble = (double.tryParse(_cQtd.text) ?? 0.0);
          _cQtd.text = valueAsDouble.toStringAsFixed(unity[newValue]);

          this.selectedUnit = newValue;
        });
      },
      items: unity.keys.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    );

    final inputValor = TextFormField(
      controller: _cValor,
      autofocus: false,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        hintText: 'Valor R\$',
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      validator: (value) {
        if (currencyToDouble(value) < 0.0) {
          return 'Obrigatório';
        }
        return null;
      },
    );

    Container content = Container(
        child: Form(
      key: _formKey,
      child: ListView(shrinkWrap: true, padding: EdgeInsets.all(20), children: <
          Widget>[
        Text(
          "Editar: '" + ItemEditPage.item['name'].toString() + "'",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        SizedBox(height: 10),
        Text('Nome do item'),
        inputName,
        SizedBox(height: 10),
        Text('Quantidade'),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 150,
                child: inputQuantidade,
              ),
              Container(width: 100, child: inputUnit)
            ]),
        SizedBox(height: 10),
        Text('Valor'),
        inputValor,
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Transform.scale(
              scale: 2.0,
              child: Checkbox(
                activeColor: Layout.primary(),
                onChanged: (bool value) {
                  setState(() {
                    this.isSelected = value;
                  });
                },
                value: this.isSelected,
              ),
            ),
            GestureDetector(
              child:
                  Text('Já está no carrinho?', style: TextStyle(fontSize: 18)),
              onTap: () {
                setState(() {
                  this.isSelected = !this.isSelected;
                });
              },
            )
          ],
        ),
        SizedBox(height: 10),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // background
                  onPrimary: Colors.white, // foreground
                ),
                child:
                    Text('Cancelar', style: TextStyle(color: Layout.light())),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // background
                  onPrimary: Colors.white, // foreground
                ),
                child: Text('Salvar', style: TextStyle(color: Layout.light())),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    // Adiciona no banco de dados
                    itemBo.update({
                      'fk_lista': ItemsPage.pkList,
                      'name': _cName.text,
                      'quantidade': _cQtd.text,
                      'precisao': unity[this.selectedUnit],
                      'valor': _cValor.text,
                      'checked': this.isSelected,
                      'created': DateTime.now().toString()
                    }, ItemEditPage.item['pk_item']).then((saved) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed(ItemsPage.tag);
                    });
                  }
                },
              )
            ])
      ]),
    ));

    return Layout.getContent(context, content, false);
  }
}
