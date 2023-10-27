# Milestone2

# 개발 & 실행환경

- gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0
- GNU Make 4.2.1

# 수행시간 분석 및 개선방안

time.h 헤더파일을 이용해 각 함수에서 소요되는 시간을 측정

```
project2$ make clean
project2$ make
project2$ ./main < {1~5.0.txt} > {1~5.1~6.out}
```

- n.0.txt는 input 파일을 의미
- n.1.txt는 개선사항을 적용하지 않은 상태에서 결과를 출력
- n.2~5.txt는 이전 단계로부터 개선사항을 합친 상태에서 결과를 출력

![1.1.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled.png)

1.1.txt

![3.1.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%201.png)

3.1.txt

![2.1.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%202.png)

2.1.txt

![4.1.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%203.png)

4.1.txt

![5.1.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%204.png)

5.1.txt

## 1.0.txt

### input 설명

- key값이 순서대로 정렬된 100000개의 insert 명령
- db가 빈 상태에서 처음 추가될 때를 살펴봄

### 분석

- find_leaf()가 약 insert의 두배만큼 호출되고 총 수행  시간의 약 17%를 차지함
    - db_insert()에서 db_find()가 호출되고 그 안에서 find_leaf를 호출
    - db_insert()에서 이후에 find_leaf 한번더 호출
    - 이 두번의 호출을 한번에 처리하는 방안을 생각
- load_page(): 두번째로 큰 비중을 차지하는 함수
    - free하고 다시 load_page()하는 과정을 없애는 방안을 생각

## 2.0.txt

### input 설명

- db 파일이 없는 상태에서 1.in으로 수행 후 10000번의 delete 명령을 수행하는 input

### 분석

- 위에서와 마찬가지로 delete가 발생할 때도 db_find()를 수행 후 한번 더 find_leaf()를 수행해 find_leaf()의 횟수가 많고 약 20%가량의 시간을 차지함

## 3.0.txt

### input 설명

db파일이 없는 상태에서 1.0.txt로 실행 후 100000번의 find 명령을 수행하는 input

## 4.0.txt

### input 설명

- db가 빈 상태에서 leaf node split이 한번 일어날때 까지 insert를 하고 그 후 10000번 delete와 insert를 반복함

## 5.0.txt

### input 설명

- db가 빈 상태에서 시작하는 insert, delete, find가 모두 포함된 input
- insert는 총 명령의 약 60%, delete는 약 20%, find는 약 20%를 차지함

# 개선

## find_leaf의 호출 횟수 줄이기 (n.2.txt)

### 아이디어

- db_insert()와 db_delete()에서 각각 db_find()와 leaf_find()가 한번씩 실행
- 이때 db_find()에서도 leaf_find()가 실행되므로 insert, delete 시에 불필요하게 leaf_find()가 두번씩 실행됨
- db_find()를 실행할 때 leaf_find()의 수행 결과를 인자로 전달받은 *leaf_offset에 저장해서 db_insert()와 db_delete()에서 사용하기

### 구현

```c
//char * db_find(int64_t key); -> 기존 함수
char * db_find(int64_t key, off_t* leaf_offset) {
	...
	off_t fin = find_leaf(key);
	*leaf_offset = fin;
	...
}
```

```c
int db_insert(int64_t key, char * value) {
	...
  //dupcheck = db_find(key);
	off_t leaf_offset;
	dupcheck = db_find(key, &leaf_offset);
	...
	//off_t leaf = find_leaf(key);
	off_t leaf = leaf_offset; //find_leaf 호출x
	...
}
    
```

```c
int db_delete(int64_t key) {
	...
	//char * check = db_find(key);
	off_t leaf_offset;
	char * check = db_find(key, &leaf_offset);
	...
	//off_t deloff = find_leaf(key);
	off_t deloff = leaf_offset; //find_leaf 호출x
	...
}
```

### 결과

- load_page 횟수를 많이 줄임

![1.2.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%205.png)

1.2.txt

![3.2.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%206.png)

3.2.txt

![5.2.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%207.png)

5.2.txt

![2.2.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%208.png)

2.2.txt

![4.2.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%209.png)

4.2.txt

## find_leaf()에서 이분탐색 사용 (n.3.txt)

### 아이디어

- find_leaf()의 while (i < p→num_of_keys) 부분을 이분탐색을 사용하면 시간을 조금이라도 줄일 수 있지 않을까 생각함
- find_leaf()에서 i 값을 구하는 과정을 binary_search()의 return으로 대체
    - i는 0~(n-1)로 몇번째 자식을 따라가야 하는지를 나타냄

### 구현

```c
int binary_search (page* p, int64_t key) {
    int left = 0;
    int right = p->num_of_keys-1;
    int mid;

    while (left <= right) {
        mid = (left + right) / 2;
        if (p->b_f[mid].key == key) return mid+1;

        if (p->b_f[mid].key > key) right = mid - 1;
        else left = mid + 1;
    }

    if (p->b_f[mid].key > key) return mid;
    else return mid+1;
}
```

```c
off_t find_leaf(int64_t key) {
	...
	while (!p->is_leaf) {
	//i = 0;
  i = binary_search(p, key);
  //while (i < p->num_of_keys) {
  //  if (key >= p->b_f[i].key) i++;
  //  else break;
	//}
```

### 결과

- 5개의 테스트 케이스 모두에서 특별한 개선 효과 없음
- 해당 개선사항은 다시 되돌림
- 개선 효과가 없는 것은 메모리 연산을 줄이는 것은 크게 의미가 없기 때문으로 이해함

## delay merge (n.4.txt)

### 아이디어

- 노드의 split, merge가 빈번하게 발생하는 input data의 경우

### 구현

```c
void delete_entry(int64_t key, off_t deloff) {
	...
	//if (why <= max) {
	if (why <= max && not_enough->num_of_keys == 0) {
		...
	}
	...
}
```

### 결과

![1.4.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%2010.png)

1.4.txt

![3.4.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%2011.png)

3.4.txt

![5.4.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%2012.png)

5.4.txt

![2.4.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%2013.png)

2.4.txt

![4.4.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%2014.png)

4.4.txt

## load_page 호출 줄이기 (n.5.txt)

### 아이디어

- 함수 인자로 page의 offset을 넘기고 그 offset으로 load_page()를 호출하는 것에서 page 포인터를 넘겨 load_page하는 횟수를 줄여보기로 함

### 구현 - insert_into_leaf()

```c
//off_t insert_into_leaf(off_t leaf, record inst);
off_t insert_into_leaf(off_t leaf, record inst, page* p) {
	...
	//page * p = load_page(leaf);
	...
}
```

```c
int db_insert(int64_t key, char * value) {
	...
	if (leafp->num_of_keys < LEAF_MAX) {
		//insert_into_leaf(leaf, nr);
	  insert_into_leaf(leaf, nr, leafp);
    //free(leafp);
		...
    return 0;
  }
	...
}
```

### 구현 - insert_into_leaf_as()

```c
//off_t insert_into_leaf_as(off_t leaf, record inst);
off_t insert_into_leaf_as(off_t leaf, record inst, page* ol) {
	...
	//page * ol = load_page(leaf);
	...
}
```

```c
int db_insert(int64_t key, char * value) {
	...
	//insert_into_leaf_as(leaf, nr);
	insert_into_leaf_as(leaf, nr, leafp);
	...
}
```

### 결과

![1.5.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%2015.png)

1.5.txt

![3.5.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%2016.png)

3.5.txt

![5.5.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%2017.png)

5.5.txt

![2.5.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%2018.png)

2.5.txt

![4.5.txt](Milestone2%201d212dbb69c14d82a26b0e4d5bdd30db/Untitled%2019.png)

4.5.txt

# 문제 해결

## load_page 호출 줄이기 (n.5.txt)

### 구현 - delete_entry(), remove_entry_from_page() (실패)

```c
//void remove_entry_from_page(int64_t key, off_t deloff);
void remove_entry_from_page(int64_t key, off_t deloff, page * lp) {
	...
	//page * lp = load_page(deloff);
	lp = load_page(deloff);
	...
	//free(lp);
	...
	if (lp->is_leaf) {
		...
		if (deloff == hp->rpo) {
			...
			//free(lp);
			...
		}
	}
	else {
		...
		if (deloff == hp->rpo) {
			//free(lp);
			...
		}
		...
		//free(lp);
		...
	}
}
```

```c
void delete_entry(int64_t key, off_t deloff) {
	...
	page* not_enough;
	//remove_entry_from_page(key, deloff);
	remove_entry_from_page(key, deloff, not_enough);

	//page * not_enough = load_page(deloff);
	...
	if (deloff == hp->rpo) {
		...
		free(not_enough);
		...
	}
	...
}
```

- 문제: make시 ‘Segmentation fault (core dumped)’ 발생
- 원인파악: 허가되지 않은 메모리의 접근에 대한 오류
- 시도1: 함수를 수정하는 과정에서 remove_entry_from_page()에서 lp가 root node일때 free(lp)를 하고 다시 delete_entry()로 복귀하는데 이때 not_enough의 주소 공간이 free된 상태이기 때문에 접근할 수 없는 오류 발생. → 수정 후에도 똑같이 오류 발생
- 원인파악2: delete_entry()의 첫번째 if문 종료 후에 not_enough에 접근할 때 발생하는 것으로 확인
- 결과: 해결 방안을 찾지 못해 해당 구현 내용은 되돌림

# references

[Segmentation Fault 세그멘테이션 오류 (Core dumped)](https://codedatasotrage.tistory.com/50)