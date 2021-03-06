# JSON_Beef
A JSON parser library made in the Beef programming language.

This is still a work in progress.

## Summary
- [Project Organization](#project-organization)
- [Adding JSON_Beef to your project](#Adding-JSON_Beef-to-your-project)
- [Using the library](#Using-the-library)
- [Important notes](#Important-notes)
- [Todo](#Todo)

## Project organization
This repository consist of two distinct folders:
- JSON_Beef_Test: A program to test the objects and methods from the JSON_Beef lib.
- lib: The JSON_Beef library.

The JSON_Beef library depends on the Beef Extensions Library that can be found here: [Beef Extensions Library](https://github.com/Jonathan-Racaud/Beef-Extensions-Lib).

## Adding JSON_Beef to your project
1. Clone the Beef Extensions Library in the location of your choice.
2. Clone the JSON_Beef library in the location of your choice.
3. In Beef IDE, right click on Workspace->Add existing project.
4. Select the BeefProj.toml file ffrom the JSON_Beef project.
5. Repeat step 3 and 4 for the Beef Extensions Library.
6. Open your project's properties.
7. Go to General->Dependencies
8. Tick JSON_Beef (you can also tick Beef Extensions Library, but it should be added as dependencies automatically when building).
9. You can now start using the library.


## Using the library
JSON_Beef consists of several objects to manipulate JSON data:
- JSONDocument: Used to validate and parse a JSON String into either a **JSONObject** or a **JSONArray**
- JSONObject: Class representing a JSON Object.
- JSONArray: Class representing a JSON Array.
- JSONValidator: Class implementing the JSON specification validation rules.
- JSONUtil: Utility class for working with certain aspect of the JSON specification.
- JSONSerializer: Class serializing an Object into either a **JSONObject** a **JSONArray** or **String** object.
- JSONDeserializer: Class deserializing a JSON String into an Object of the specified type **(Work in progress)**
- JsonList<T>: Class inheriting from List<T> to allow Deserialization of JSON Lists into a List<T> like class. This class does not provided more methods than a List<T>. Its only use is for being able to find the *Add* method through reflection.

**Validating a JSON String:**
```c#
JSONValidator.IsValidJson(jsonString);
```

**Parsing a JSON String into a JSONArray:**
```c#
let doc = scope JSONDocument();
if (JSONValidator.IsValidJson(data) && (doc.GetJsonType(data) == .ARRAY))
{
    let array = doc.ParseArray(data);
    
    // Work with the JSONArray object.

    // You are responsible for the deletion of the JSONArray.
    delete array.Get();
}
```

**Parsing a JSON String into a JSON Object:**
```c#
let doc = scope JSONDocument();
if (JSONValidator.IsValidJson(data) && (doc.GetJsonType(data) == .OBJECT))
{
    let array = doc.ParseObject(data);
    
    // Work with the JSONAObject object.

    // You are responsible for the deletion of the JSONObject.
    delete array.Get();
}
```

**Serializing a user defined class:**
Serializing a user defined class uses reflection so in order for it to work, you must declare your class like so:
```c#
[AlwaysInclude(AssumeInstantiated=true, IncludeAllMethods=true)] // Allows for the type to be created via reflection (used by the Deserializer).
[Reflect] // Allows for the type's fields to be discoverable via reflection in order to serialize them.
public class CustomClass
{
    // public fields will be automatically serialized.
    public String Name;

    // This attributes allows for ignoring fields.
    [IgnoreSerialize]
    public String IgnoredField;

    // Private fields are ignored.
    private int mRandomId;
}
```

You can then use the JSONSerializer class like so:
```c#
let jsonObject = JSONSerializer.Serialize<JSONObject>(object);
let jsonArray = JSONSerializer.Serialize<JSONArray>(object);
let str = JSONSerializer.Serialize<String>(object);
```

**Deserializing a user defined class:**
In order to deserialize a user defined type, it must be marked with the following attributes:
```c#
[AlwaysInclude(AssumeInstantiated=true, IncludeAllMethods=true)] // Allows for the type to be created via reflection (used by the Deserializer).
[Reflect] // Allows for the type's fields to be discoverable via reflection in order to serialize them.
```

Now you can deserialize a JSON string into your CustomClass using JSONDeserializer:
```c#
let customClass = JSONDeserializer.Deserialize<CustomClass>(json);
```

For more examples about how to use the library you can look at the JSON_Beef_Test project.

## Important notes
- For the moment, when deserializing into a user defined type, the keys inside the JSON object string representation must match the field's name as declared (case sensitive):

```c#
public class Person
{
    public String FirstName;
}

let wrongJson = "{\"Firstname\": \"Jonathan\"}";
let person = JSONDeserialize<Person>(wrongJson); // Will not yield expected results because the type Person doesn't have a field named: Firstname.

let rightJson = "{\"FirstName\": \"Jonathan\"}";
let person = JSONDeserialize<Person>(rightJson); // the person object will successfully be serialized.
```

## Todo
- JSON String parsing:
  - Handle unescaped characters in strings as error.
  - Parse UTF-8 characters e.g.: u0063.
- Reflection based Object deserialization:
  - Handle Dictionary types.
  - Handle properties.