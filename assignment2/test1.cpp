#include <bits/stdc++.h>
using namespace std;

class name_age {
	public:
		string name;
		string age;
		
		void set_name_age(string tuple)
		{
			stringstream tuplestr(tuple);
			string agestr;

			getline(tuplestr, name, ',');
			getline(tuplestr, age);
		}
};

class name_salary {
	public:
		string name;
		string salary;
		
		void set_name_salary(string tuple)
		{
			stringstream tuplestr(tuple);
			string salarystr;

			getline(tuplestr, name, ',');
			getline(tuplestr, salary);
		}
};

string make_tuple(string name, string age, string salary)
{
	return name+ ',' + age + ',' + salary + '\n';
}

int main(){

	string buffer[2];
	name_age temp0;
	name_salary temp1;
	int current_block[2] = {};
	fstream block[12];
	ofstream output;

	output.open("./output1.csv");

	if(output.fail())
	{
		cout << "output file opening fail.\n";
	}

	/*********************************************************************************/
	
	current_block[0] = 0;
	current_block[1] = 0;

	temp0.name = "";
	temp1.name = "";	
	
	while (true) {
		//temp0의 이름이 크면 temp1을 다음 tuple로 읽기
		if (temp0.name >= temp1.name) {
			//read name_salary
			if (!getline(block[1], buffer[1])) {
				//read a block
				block[1].close();
				if (current_block[1] == 1000) break;
				block[1].open("./case1/name_salary/"+to_string(current_block[1]++)+".csv");
				getline(block[1], buffer[1]);
			}
			temp1.set_name_salary(buffer[1]);
		}
		//temp0의 이름이 크지 않으면 temp0을 다음 tuple로 읽기
		else {
			//read name_age
			if (!getline(block[0], buffer[0])) {
				//read a block
				block[0].close();
				if (current_block[0] == 1000) break;
				block[0].open("./case1/name_age/"+to_string(current_block[0]++)+".csv");
				getline(block[0], buffer[0]);
			}
			temp0.set_name_age(buffer[0]);
		}
		
		if (temp0.name == temp1.name) {
			output << make_tuple(temp0.name, temp0.age, temp1.salary);
		}		
	}


	/*********************************************************************************/


	output.close();
}
