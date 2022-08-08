import 'package:flutter_sanity/flutter_sanity.dart';

const projectId = 'g71nhdwa';
const dataset = 'production';

class Sanity {
  final sanityClient = SanityClient(projectId: projectId, dataset: dataset);
}
