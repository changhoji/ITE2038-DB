#include <bits/stdc++.h>
using namespace std;

class name_grade {
	public:
		string student_name;
		int korean;
		int math;
		int english;
		int science;
		int social;
		int history;

		void set_grade(string tuple)
		{
			stringstream tuplestr(tuple);
			string tempstr;

			getline(tuplestr, student_name, ',');

			getline(tuplestr, tempstr, ',');
			korean = stoi(tempstr);
			
			getline(tuplestr, tempstr, ',');
			math = stoi(tempstr);
			
			getline(tuplestr, tempstr, ',');
			english = stoi(tempstr);
			
			getline(tuplestr, tempstr, ',');
			science = stoi(tempstr);
			
			getline(tuplestr, tempstr, ',');
			social = stoi(tempstr);
			
			getline(tuplestr, tempstr);
			history = stoi(tempstr);
		}
};

class name_number{
	public :
		string student_name;
		string student_number;

		void set_number(string tuple)
		{
			stringstream tuplestr(tuple);
			string tempstr;


			getline(tuplestr, student_name, ',');
			getline(tuplestr, student_number, ',');
		}
};

string make_tuple(string name, string number)
{
	string ret = "";

	ret += name+ "," + number +"\n";

	return ret;
}

int hashfunc(string name, int div) {
	int sum = 0;
	int mul = 1;
	for (int i = 0; i < name.size(); i++) {
		mul *= 3;
		sum += name[i]*mul;
	}
	return sum%div;
}

int main(){

	string buffer[2];
	name_grade temp0;
	name_grade temp1;
	name_number temp2;
	fstream block[12];
	ofstream output;

	output.open("./output3.csv");

	if(output.fail())
	{
		cout << "output file opening fail.\n";
	}

	/*********************************************************************/

	int current_block = 0;

	//name_grade1을 저장할 hash file 열기
	for (int i = 0; i < 11; i++) {
		block[i].open("./bucket/name_grade1/"+to_string(i)+".csv", fstream::out | fstream::trunc);
	}

	//name_grade1의 튜플들 읽기
	while (true) {
		if (!getline(block[11], buffer[0])) {
			block[11].close();
			if (current_block == 1000) break;
			block[11].open("./case3/name_grade1/"+to_string(current_block++)+".csv");
			getline(block[11], buffer[0]);
		}
		temp0.set_grade(buffer[0]);
		int hash = hashfunc(temp0.student_name, 11);

		//해당하는 hash file에 쓰기
		block[hash] << buffer[0] << '\n';
	}

	//name_grade2를 저장할 hash file 열기
	for (int i = 0; i < 11; i++) {
		block[i].close();
		block[i].open("./bucket/name_grade2/"+to_string(i)+".csv", fstream::out | fstream::trunc);
	}

	current_block = 0;

	//name_grade2의 튜플들 읽기
	while (true) {
		if (!getline(block[11], buffer[0])) {
			block[11].close();
			if (current_block == 1000) break;
			block[11].open("./case3/name_grade2/"+to_string(current_block++)+".csv");
			getline(block[11], buffer[0]);
		}
		temp0.set_grade(buffer[0]);
		int hash = hashfunc(temp0.student_name, 11);

		//해당하는 hash file에 쓰기
		block[hash] << buffer[0] << '\n';
	}

	for (int i = 0; i < 11; i++) block[i].close();
	//
	// grade1과 grade2를 join하기 위한 hash 처리 끝
	//

	//name_grade1과 name_grade2를 join하고 두개 과목 이상의 성적이 향상된 학생을 다시 한번 hash로 나눠서 저장

	//block 두개는 각각 name_grade1과 name_grade2를 읽기 위해 남겨둠
	for (int i = 0; i < 10; i++) {
		block[i].open("./bucket/name_up_grades/"+to_string(i)+".csv", fstream::out | fstream::trunc);
	}
	
	current_block = 0;

	//bucket / name_grade1과 name_grade2 보고 다시 hash로 name_up_grades에 쓰기
	for (int i = 0; i < 11; i++) {
		block[10].open("./bucket/name_grade1/"+to_string(i)+".csv");
		/* */block[11].open("./bucket/name_grade2/"+to_string(i)+".csv");

		//grade1 읽기
		while(getline(block[10], buffer[0])) {
			temp0.set_grade(buffer[0]);

			/* */block[11].seekg(ios::beg);			
			/* block[11].open("./bucket/name_grade2/"+to_string(i)+".csv"); */
			//각각의 grade1에 대해 block[11]로 grade2 읽기
			while (getline(block[11], buffer[1])) {
				temp1.set_grade(buffer[1]);
				//두개 이상의 과목에서 성적이 향상되었는지 보기

				//우선 이름이 다르면 건너뛰기
				if (temp0.student_name != temp1.student_name) continue;

				//성적 향상된 과목 있는지 보기
				int cnt = 0;
				if (temp0.korean > temp1.korean) cnt++;
				if (temp0.math > temp1.math) cnt++;
				if (temp0.english > temp1.english) cnt++;
				if (temp0.science > temp1.science) cnt++;
				if (temp0.social > temp1.social) cnt++;
				if (temp0.history > temp1.history) cnt++;
				if (cnt >= 2) {
					// printf("asdf\n");
					int hash = hashfunc(temp0.student_name, 10);
					block[hash] << temp0.student_name << '\n';
					//student_name이 key이므로 현재 while문에서는 더 찾을 필요 없음
				}
				//join attribute가 같았으면 넘어가기
				break;
			}
			/* block[11].close(); */
		}

		block[10].close();
		block[11].close();
	}

	//
	// name_up_grades에 두개 이상의 과목의 성적이 향상된 student_name을 저장 끝
	//

	//성적 향상 join에서 사용되고, 다시 hash로 쓰는데 사용한 fstream 닫기
	for (int i = 0; i < 12; i++) block[i].close();

	//name_grade1과 name_grade2의 join 결과를 name_number와 join하기 위해 name_number를 읽고 partitioning
	for (int i = 0; i < 10; i++) {
		block[i].open("./bucket/name_number/"+to_string(i)+".csv", fstream::out | fstream::trunc);
	}

	while (true) {
		//block[11]: name_number를 읽을 block
		if (!getline(block[11], buffer[0])) {
			block[11].close();
			if (current_block == 1000) break;
			block[11].open("./case3/name_number/"+to_string(current_block++)+".csv");
			getline(block[11], buffer[0]);
		}
		temp2.set_number(buffer[0]);
		int hash = hashfunc(temp2.student_name, 10);

		//partition에 쓰기
		block[hash] << buffer[0] << '\n';
	}
	
	for (int i = 0; i < 12; i++) block[i].close();

	//
	// name_number 나누기 끝내고 마지막 output을 위해 hash join 시키기
	//

	//10개로 partitioning 했음
	for (int i = 0; i < 10; i++) {
		block[0].open("./bucket/name_up_grades/"+to_string(i)+".csv");
		/* */block[1].open("./bucket/name_number/"+to_string(i)+".csv");

		//name_up_grades 읽기
		while (getline(block[0], buffer[0])) {
			//name_up_grades에는 name만 있기 때문에 string 그대로 사용

			/* */block[1].seekg(ios::beg);
			/* block[1].open("./bucket/name_number/"+to_string(i)+".csv"); */

			while (getline(block[1], buffer[1])) {
				//name_number의 tuple 읽기
				temp2.set_number(buffer[1]);
				
				//buffer[0]과 temp2의 name 비교
				if (buffer[0] == temp2.student_name) {
					output << make_tuple(temp2.student_name, temp2.student_number);
					//name이 key이므로 다음 name_up_grades tuple 보기
					break;
				}
			}
			/* block[1].close(); */
		}

		block[0].close();
		block[1].close();
	}
	


	/*********************************************************************/


	output.close();

	
}
