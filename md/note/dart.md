# Dart

## Flutter

### Retrofit

```dart
// pubspec.yml
dependencies:
  retrofit: ">=4.0.0 <5.0.0"
dev_dependencies:
  retrofit_generator: "^5.0.0"
  build_runner: "^2.3.3"
  json_serializable: "^6.6.1"
```

```dart
// example.dart
import "package:dio/dio.dart";
import "package:json_annotation/json_annotation.dart";
import "package:retrofit/retrofit.dart";

part "example.g.dart";

@RestApi(baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/")
abstract class RestClient {
    factory RestClient(Dio dio, {String baseUrl}) = _RestClient;
    @GET("/tasks")
    Future<List<Task>> getTasks();
}

@JsonSerializable()
class Task {
    Task({this.id, this.name, this.avatar, this.createdAt});
    factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
    String? id;
    String? name;
    String? avatar;
    String? createdAt;
    Map<String, dynamic> toJson() => _$TaskToJson(this);
}
```

```dart
// widget_build.dart
...
ElevatedButton(
    onPressed: () async {
        final dio = Dio(); // Provide a dio instance
        dio.options.headers["Demo-Header"] = "demo header"; // config your dio headers globally
        final client = RestClient(dio);
        await client.getTasks().then((it) {
            for (final task in it) {
            Stra.log("Task:${task.id}/${task.name}");
            }
        });
    },
    child: const Text("Retrofit"),
),
...
```

### OpenApiGenerator

```yml
# ./../openapi/oas/example.yml
openapi: 3.0.3
info:
  title: "Sample API"
  version: "1.0.0"

paths:
  "/dateid":
    get:
      summary: "dateid"
      responses:
        "200":
          description: "成功"
          content:
            application/json:
              schema:
                type: string
                example: "20230315165159958"
  "/api/ok":
    get:
      summary: "ok"
      responses:
        "200":
          description: "成功"
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/dateid'
                example:
                  - message: ok

components:
  schemas:
    dateid:
      type: object
      required:
        - message
      properties:
        message:
          type: string 
```

```bash
## ./../openapi/setup.sh
BASE="$(dirname "$(readlink -f "${BASH_SOURCE:-0}")")"
OPENAPI="$BASE/openapi-generator-cli.jar"
if [[ ! -f "${OPENAPI}" ]] ; then
    curl "https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/6.3.0/openapi-generator-cli-6.3.0.jar" -o $OPENAPI
fi
## openapi/oas/* loop
SEARCH_TARGET="$BASE/oas"
SEARCH_TARGET_ALLOW=("json" "yaml" "yml")
SEARCH_TARGET_SKIP=(
    ".gitkeep"
    #"example.yml"
)

## clean
rm -Rf ${BASE}/client/*

while read -r FP; do #echo "file path: $FP";
    FE="${FP##*.}"; #echo "file extension:$FE";
    if `echo ${SEARCH_TARGET_ALLOW[@]} | grep -q "$FE"`; then ## extension check
        FN="${FP##*/}"; #echo "file name:$FN";
        if ! `echo ${SEARCH_TARGET_SKIP[@]} | grep -q "$FN"`; then ## skip
            FBN="${FN%.*}"; #echo "file base name:$FBN";

            ## split for console log
            seq -s- $(tput cols) | tr -d '[:digit:]'

            ## OpenAPI Generator Reference
            ## https://openapi-generator.tech/docs/usage
            ## https://openapi-generator.tech/docs/generators/dart/

            ## dirctory generate for .openapi-generator-ignore
            # mkdir -p ${BASE}/client/${FBN} && cp -n $BASE/.openapi-generator-ignore ${BASE}/client/${FBN}/
            
            ## validate
            java -jar ${OPENAPI} validate -i ${BASE}/oas/${FBN}.${FE}

            ## client generate
            java -jar ${OPENAPI} \
                generate \
                -g dart \
                -i ${BASE}/oas/${FBN}.${FE} \
                -o ${BASE}/client/${FBN} \
                --skip-validate-spec \
                --global-property=apiTests=false,modelTests=false,apiDocs=false,modelDocs=false \
                --additional-properties="pubVersion=1.0.1,pubName=${FBN}"
        fi
    fi
done < <(find $SEARCH_TARGET -mindepth 1 -maxdepth 1)

```

```yml
## pubspec.yml
dependencies:
    ## OpenApi:https://github.com/OpenAPITools/openapi-generator/blob/master/docs/generators/dart.md
    http: ">=0.13.0 <0.14.0"
    intl: "^0.17.0"
    meta: "^1.1.8"
    ## OpenApi.example
    example:
        path: ./openapi/client/example
dev_dependencies:
    test: ^1.22.0
```

```dart
//analysis_options.yaml
analyzer:
  exclude:
    - openapi/client/**
```

```dart
// widget_build.dart
ElevatedButton(
    onPressed: () async {
        final endpoint.DefaultApi api = endpoint.DefaultApi(
            endpoint.ApiClient(basePath: "https://example.com/"),
        );
        final String dateid = (await api.dateidGet())!;
        print("dateid:$dateid");
    },
    child: const Text("OpenAPI-Generator"),
),
```