import 'package:flutter/material.dart';
import 'package:olx/models/Anuncio.dart';

class ItemAnuncio extends StatelessWidget {
  Anuncio anuncio;
  VoidCallback? onTapItem;
  VoidCallback? onPressedRemover;

  ItemAnuncio(
      {required this.anuncio,
      this.onTapItem,
      this.onPressedRemover,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapItem,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                  width: 120,
                  height: 120,
                  child: Image.network(
                    anuncio.fotos![0],
                    fit: BoxFit.cover,
                  )),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        anuncio.titulo!,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text("R\$ ${anuncio.preco}")
                    ],
                  ),
                ),
              ),
              if (onPressedRemover != null)
                Expanded(
                    flex: 1,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.all(10)),
                      onPressed: onPressedRemover,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ))
            ],
          ),
        ),
      ),
    );
  }
}
