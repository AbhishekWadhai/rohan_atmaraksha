import 'package:flutter/material.dart';
import 'package:rohan_suraksha_sathi/app_constants/asset_path.dart';

class RohanProgressIndicator extends StatelessWidget {
  const RohanProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 100,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Image.asset(Assets.rohanLogo),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageProgressIndicator extends StatelessWidget {
  const ImageProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 150,
        width: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Icon(
                Icons.image,
                size: 40,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationProgressIndicator extends StatelessWidget {
  const LocationProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 150,
        width: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 40,
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
