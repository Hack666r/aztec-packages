struct Foo {
    bar: Field,
    array: [Field; 2],
}

struct Pair {
    first: Foo,
    pub second: Field,
}

impl Foo {
    fn default(x: Field, y: Field) -> Self {
        Self { bar: 0, array: [x, y] }
    }
}

impl Pair {
    fn foo(p: Self) -> Foo {
        p.first
    }

    fn bar(self) -> Field {
        self.foo().bar
    }
}

struct Nested {
    a: Field,
    b: Field,
}
struct MyStruct {
    my_bool: bool,
    my_int: u32,
    my_nest: Nested,
}
fn test_struct_in_tuple(a_bool: bool, x: Field, y: Field) -> (MyStruct, bool) {
    let my_struct = MyStruct { my_bool: a_bool, my_int: 5, my_nest: Nested { a: x, b: y } };
    (my_struct, a_bool)
}

struct Animal {
    legs: Field,
    eyes: u8,
}

fn get_dog() -> Animal {
    let dog = Animal { legs: 4, eyes: 2 };
    dog
}

fn main(x: Field, y: Field) {
    let first = Foo::default(x, y);
    let p = Pair { first, second: 1 };

    assert(p.bar() == x);
    assert(p.second == y);
    assert(p.first.array[0] != p.first.array[1]);

    // Nested structs
    let (struct_from_tuple, a_bool) = test_struct_in_tuple(true, x, y);
    assert(struct_from_tuple.my_bool == true);
    assert(a_bool == true);
    assert(struct_from_tuple.my_int == 5);
    assert(struct_from_tuple.my_nest.a == 0);

    // Regression test for issue #670
    let Animal { legs, eyes } = get_dog();
    let six = legs + eyes as Field;

    assert(six == 6);

    let Animal { legs: _, eyes: _ } = get_dog();
}
