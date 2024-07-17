import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String serviceImageUrl;
  final String clientName;
  final String clientEmail;
  final String reviewText;
  final String serviceName;
  final double rating;
  final String date;

  ReviewCard({
    required this.serviceImageUrl,
    required this.clientName,
    required this.clientEmail,
    required this.serviceName,
    required this.reviewText,
    required this.rating,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Container(
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFFBBC04)),
          color: Color.fromARGB(255, 243, 233, 204),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 15),
              child: Row(
                children: [
                  Image.network(
                    serviceImageUrl, // Replace with the actual image URL
                    width: 40,
                    height: 40,
                    fit: BoxFit
                        .cover, // Choose the appropriate BoxFit based on your design
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clientName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          clientEmail,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          "Service: ${serviceName}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Text(
                reviewText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      SizedBox(width: 5),
                      Text(rating.toStringAsFixed(1)),
                    ],
                  ),
                  Text(
                    convertTo12HourFormat(date),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String convertTo12HourFormat(String time24Hour) {
    String date = time24Hour.split(' ')[0];

    return date;
  }
}
