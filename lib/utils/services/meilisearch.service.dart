import 'package:meilisearch/meilisearch.dart';


MeiliSearchClient getSearchClient(String url, String key) {
  return MeiliSearchClient(url, key);
}

Future<MeiliSearchIndex> getSearchIndex(MeiliSearchClient client, String indexName) async {
  return await client.getIndex(indexName);
}

Future<List<Map<String, Object?>>?> search(MeiliSearchIndex index, String query) async {
  var response =  await index.search(query);
  return response.hits;
}