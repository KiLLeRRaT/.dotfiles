namespace HelloWorld
{
	public class Test
	{
		public static Test()
		{
			System.Console.WriteLine("Hello, World!");
		}

		private void privAreYouSure()
		{
			System.Console.WriteLine("Are you sure?");
		}

		private int privAdd(int a, int b)
		{
			return a + b;
		}

		private int privSub(int a, int b)
		{
			return a - b;
		}

		public int GetAge()
		{
			return 25;
		}

		public string GetName()
		{
			return "John";
		}

		public static string GetSkyColor()
		{
			return "Blue";
		}
	}
}
