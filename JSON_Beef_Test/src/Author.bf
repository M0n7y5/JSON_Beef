using System;
using System.Collections;
using JSON_Beef.Attributes;

namespace JSON_Beef_Test
{
	[AlwaysInclude(AssumeInstantiated=true, IncludeAllMethods=true)]
	[Reflect]
	public class Person
	{
		public String FirstName = new .() ~ delete _;
		public String LastName = new .() ~ delete _;

		[IgnoreSerialize]
		public int Age;

		/*public ~this()
		{
			delete FirstName;
			delete LastName;
		}*/
	}

	[AlwaysInclude(AssumeInstantiated=true, IncludeAllMethods=true)]
	[Reflect]
	public class Author: Person
	{
		public int Id;
		public float Test;
		public static bool Known;
		public Book FirstBook = new .() ~ delete _;
		public List<Book> Books = new List<Book>() ~ DeleteContainerAndItems!(Books);
		public List<String> Publishers = new List<String>() ~ DeleteContainerAndItems!(Publishers);

		[IgnoreSerialize]
		public static int ToBeIgnored = 42;

		public this(String firstName = "", String lastName = "", int age = 0)
		{
			FirstName.Set(firstName);
			LastName.Set(lastName);
			Age = age;
		}
	}

	[AlwaysInclude(AssumeInstantiated=true, IncludeAllMethods=true)]
	[Reflect]
	public class Book
	{
		public String Name;

		public this(String name = "Book")
		{
			Name = new String(name);
		}

		public ~this()
		{
			if (Name != null)
			{
				delete Name;
			}
		}

		public void Test()
		{

		}

		public static bool operator==(Book a, Book b)
		{
			return a.Name.Equals(b.Name);
		}

		public static bool operator!=(Book a, Book b)
		{
			return !(a == b);
		}
	}
}
