import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:jamu_saripah/Models/cart_item.dart';
import 'package:jamu_saripah/Models/product_cart.dart';
import 'package:jamu_saripah/Provider/cart_provider.dart';
import 'package:jamu_saripah/common/constasts.dart';
import 'package:provider/provider.dart';

import 'components/add_to_cart_bottom_sheet.dart';
import 'components/product_options_section.dart';

class DetailScreen extends StatefulWidget {
  final Product product;

  const DetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<DetailScreen> createState() =>
      _DetailScreenState();
}

class _DetailScreenState
    extends State<DetailScreen> {

  int quantity = 1;

  String selectedSize = "250 ml";
  String selectedOption =
      "Beras Kencur Saja";

  double currentPrice = 0;

  @override
  void initState() {
    super.initState();

    currentPrice =
        widget.product.price;
  }

  /// UPDATE PRICE
  void updatePrice(
    String size,
    String option,
  ) {

    setState(() {

      selectedSize = size;
      selectedOption = option;

      if (option.contains("Paket 3")) {

        currentPrice = 70000.0;

      } else {

        double basePrice =
            widget.product.price;

        if (size == "350 ml") {

          currentPrice =
              basePrice + 5000;

        } else if (size == "1 Liter") {

          currentPrice =
              basePrice + 10000;

        } else {

          currentPrice =
              basePrice;
        }
      }
    });
  }

  /// FORMAT RUPIAH
  String formatIDR(double amount) {

    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  /// BUILD PRODUCT IMAGE
  Widget _buildProductImage(
      String imageSource) {

    /// BASE64
    if (imageSource.length > 100) {

      try {

        return Image.memory(
          base64Decode(imageSource),

          fit: BoxFit.cover,

          width: double.infinity,

          height: 450,
        );

      } catch (e) {

        return const SizedBox(
          height: 450,

          child: Icon(
            Icons.broken_image,
          ),
        );
      }
    }

    /// SVG
    else if (imageSource
        .toLowerCase()
        .endsWith('.svg')) {

      return SvgPicture.asset(
        imageSource,

        fit: BoxFit.cover,

        width: double.infinity,

        height: 450,

        placeholderBuilder:
            (context) =>
                const SizedBox(
          height: 450,

          child: Center(
            child:
                CircularProgressIndicator(),
          ),
        ),
      );
    }

    /// NETWORK IMAGE
    else if (imageSource
        .startsWith("http")) {

      return Image.network(
        imageSource,

        fit: BoxFit.cover,

        width: double.infinity,

        height: 450,

        errorBuilder:
            (context, error, stackTrace) {

          return const SizedBox(
            height: 450,

            child: Icon(
              Icons.broken_image,
            ),
          );
        },
      );
    }

    /// LOCAL ASSET
    else {

      return Image.asset(
        imageSource,

        fit: BoxFit.cover,

        width: double.infinity,

        height: 450,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    bool isLowStock =
        widget.product.stock < 5;

    Color badgeBgColor =
        isLowStock
            ? const Color(
                0xFFFDE8E8)
            : AppColors.primaryOlive;

    Color badgeTextColor =
        isLowStock
            ? const Color(
                0xFFC53030)
            : AppColors.white;

    return Scaffold(
      backgroundColor:
          Colors.white,

      body: Stack(
        children: [

          /// MAIN CONTENT
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                /// PRODUCT IMAGE
                Stack(
                  children: [

                    _buildProductImage(
                      widget
                          .product.image,
                    ),

                    Positioned(
                      top: 50,
                      left: 20,

                      child:
                          GestureDetector(
                        onTap: () =>
                            Navigator.pop(
                                context),

                        child:
                            const CircleAvatar(
                          backgroundColor:
                              Colors.white,

                          child: Icon(
                            Icons
                                .arrow_back_ios_new,

                            size: 18,

                            color:
                                Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                /// PRODUCT DETAIL
                Padding(
                  padding:
                      const EdgeInsets
                          .all(20),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      /// TITLE + STOCK
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

                        children: [

                          Expanded(
                            child: Text(
                              widget
                                  .product
                                  .name,

                              style:
                                  const TextStyle(
                                fontSize:
                                    24,

                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),

                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal:
                                  12,

                              vertical:
                                  6,
                            ),

                            decoration:
                                BoxDecoration(
                              color:
                                  badgeBgColor,

                              borderRadius:
                                  BorderRadius.circular(
                                      30),
                            ),

                            child: Text(
                              "Sisa ${widget.product.stock} stok",

                              style:
                                  TextStyle(
                                color:
                                    badgeTextColor,

                                fontWeight:
                                    FontWeight
                                        .bold,

                                fontSize:
                                    12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                          height: 15),

                      /// PRICE
                      Text(
                        formatIDR(
                            currentPrice),

                        style:
                            const TextStyle(
                          fontSize:
                              22,

                          fontWeight:
                              FontWeight
                                  .bold,

                          color: Color(
                              0xFF7E8959),
                        ),
                      ),

                      const SizedBox(
                          height: 25),

                      /// DESCRIPTION TITLE
                      const Text(
                        "Tentang Jamu Ini",

                        style:
                            TextStyle(
                          fontSize:
                              18,

                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      const SizedBox(
                          height: 10),

                      /// DESCRIPTION
                      Text(
                        widget.product
                                .description
                                .isEmpty
                            ? "Racikan jamu tradisional ini dibuat dengan bahan alami pilihan tanpa pengawet."
                            : widget.product
                                .description,

                        style:
                            const TextStyle(
                          fontSize:
                              14,

                          height:
                              1.6,

                          color:
                              Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(
                  thickness: 10,

                  color:
                      Color(0xFFF5F5F5),
                ),

                /// OPTIONS
                ProductOptionsSection(
                  productName:
                      widget
                          .product.name,

                  onSizeChanged:
                      (size) {

                    updatePrice(
                      size,
                      selectedOption,
                    );
                  },
                ),

                const SizedBox(
                    height: 120),
              ],
            ),
          ),

          /// BOTTOM BAR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,

            child:
                _buildBottomBar(
                    context),
          ),
        ],
      ),
    );
  }

  /// BOTTOM BAR
  Widget _buildBottomBar(
      BuildContext context) {

    double totalPrice =
        currentPrice * quantity;

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),

      decoration:
          const BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color:
                Colors.black12,

            blurRadius: 10,
          ),
        ],
      ),

      child: SafeArea(
        child: Row(
          children: [

            /// QUANTITY
            Container(
              decoration:
                  BoxDecoration(
                border: Border.all(
                  color: Colors
                      .grey[300]!,
                ),

                borderRadius:
                    BorderRadius
                        .circular(
                            25),
              ),

              child: Row(
                children: [

                  /// MINUS
                  IconButton(
                    onPressed: () {

                      if (quantity >
                          1) {

                        setState(() {
                          quantity--;
                        });
                      }
                    },

                    icon: const Icon(
                      Icons.remove,
                    ),
                  ),

                  Text(
                    "$quantity",

                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  /// PLUS
                  IconButton(
                    onPressed: () {

                      setState(() {
                        quantity++;
                      });
                    },

                    icon:
                        const Icon(
                      Icons.add,

                      color: Color(
                          0xFF7E8959),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
                width: 15),

            /// BUTTON
            Expanded(
              child:
                  ElevatedButton(
                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      const Color(
                          0xFF7E8959),

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 15,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            10),
                  ),
                ),

                onPressed: () {

                  /// ADD TO CART
                  context
                      .read<
                          CartProvider>()
                      .addToCart(
                        CartItem(
                          name: widget
                              .product
                              .name,

                          price:
                              currentPrice.toInt(),

                          quantity:
                              quantity,

                          image: widget
                              .product
                              .image,

                          size:
                              selectedSize,
                        ),
                      );

                  /// SHOW BOTTOM SHEET
                  showModalBottomSheet(
                    context:
                        context,

                    isScrollControlled:
                        true,

                    backgroundColor:
                        Colors
                            .transparent,

                    builder:
                        (context) =>
                            AddToCartBottomSheet(
                      product:
                          Product(
                        name: widget
                            .product
                            .name,

                        price:
                            currentPrice,

                        image: widget
                            .product
                            .image,

                        description:
                            widget
                                .product
                                .description,

                        size:
                            selectedSize,

                        stock: widget
                            .product
                            .stock,
                      ),

                      quantity:
                          quantity,

                      size:
                          selectedSize,
                    ),
                  );
                },

                child: Text(
                  "Tambah - ${formatIDR(totalPrice)}",

                  style:
                      const TextStyle(
                    color:
                        Colors.white,

                    fontWeight:
                        FontWeight
                            .bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}