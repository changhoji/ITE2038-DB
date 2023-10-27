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

int hashfunc(string name) {
	int sum = 0;
	for (int i = 0; i < name.size(); i++) {
		sum += name[i];
	}
	return sum%11;
}

int main(){

	string buffer[2];
	name_age temp0;
	name_salary temp1;
	fstream block[12];
	ofstream output;

	output.open("./output2.csv");

	if(output.fail())
	{
		cout << "output file opening fail.\n";
	}


	/******************************************************************/
	
	int current_block[2] = { 0, 0 };

	for (int i = 0; i < 11; i++) {
		block[i].open("./bucket/name_age/"+to_string(i)+".csv", fstream::out | fstream::trunc);
	}
	
	//name_age 읽어서 hash로 나누기
	while (true) {
		//block[11]: name_age tuple들을 읽을 block
		if (!getline(block[11], buffer[0])) {
			block[11].close();
			if (current_block[0] == 1000) break;
			block[11].open("./case2/name_age/"+to_string(current_block[0]++)+".csv");
			getline(block[11], buffer[0]);
		}
		temp0.set_name_age(buffer[0]);
		int hash = hashfunc(temp0.name);

		//읽은 tuple bucket에 쓰기
		block[hash] << buffer[0] << '\n';
	}

	for (int i = 0; i < 11; i++) {
		block[i].close();
		block[i].open("./bucket/name_salary/"+to_string(i)+".csv", fstream::out | fstream::trunc);
	}

	//name_salary 읽어서 hash로 나누기
	while (true) {
		//block[11]: name_salary tuple들을 읽을 block
		if (!getline(block[11], buffer[0])) {
			block[11].close();
			if (current_block[1] == 1000) break;
			block[11].open("./case2/name_salary/"+to_string(current_block[1]++)+".csv");
			getline(block[11], buffer[0]);
		}
		temp1.set_name_salary(buffer[0]);
		int hash = hashfunc(temp1.name);

		//읽은 tuple bucket에 쓰기
		// cout << "buffer: " << buffer[0] << '\n';
		block[hash] << buffer[0] << '\n';
	}

	for (int i = 0; i < 11; i++) {
		block[i].close();
	}

	//finish hashing

	for (int i = 0; i < 11; i++) {
		block[0].open("bucket/name_age/"+to_string(i)+".csv");
		/* */block[1].open("bucket/name_salary/"+to_string(i)+".csv", fstream::in);

		//name_age 읽기
		while (getline(block[0], buffer[0])) {
			temp0.set_name_age(buffer[0]);

			//각각의 name_age block에 대해 name_salary 읽기

			/* */block[1].seekg(ios::beg);
			/* block[1].open("bucket/name_salary/"+to_string(i)+".csv", fstream::in); */
			
			while (getline(block[1], buffer[1])) {
				temp1.set_name_salary(buffer[1]);
				
				if (temp0.name == temp1.name) {
					output << make_tuple(temp0.name, temp0.age, temp1.salary);
					break;
				}
			}
			/* block[1].close(); */
		}

		block[0].close();
		block[1].close();
	}



	/******************************************************************/

	output.close();

	
}
