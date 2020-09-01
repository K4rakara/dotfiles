use crate::rand;

use rand::random;

pub(crate) trait PrefixChar {
	fn generate(&self) -> char;
	fn can_output(&self, v: char) -> bool;
}

pub(crate) struct DecimalChar;

impl DecimalChar { pub fn new() -> Self { DecimalChar } }

impl PrefixChar for DecimalChar {
	fn generate(&self) -> char {
		((random::<f32>() * 9.0).round() as u8 + 48) as char
	}
	fn can_output(&self, v: char) -> bool {
		(v as u8) - 47 <= 10
	}
}

#[cfg(test)]
mod test_decimal_char {
	use super::DecimalChar;
	use super::PrefixChar;
	#[test]
	fn test_can_output() {
		let gen = DecimalChar::new();
		for i in 0..9 {
			let as_char = {
				let working = format!("{}", i);
				working.chars().next().unwrap()
			};
			assert!(gen.can_output(as_char));
		}
	}
	#[test]
	fn test_generate() {
		let gen = DecimalChar::new();
		for i in 0..64 { assert!(gen.can_output(gen.generate())); }
	}
}

pub(crate) struct BinaryChar;

impl BinaryChar { pub fn new() -> Self { BinaryChar } }

impl PrefixChar for BinaryChar {
	fn generate(&self) -> char { if random() { '1' } else { '0' } }
	fn can_output(&self, v: char) -> bool { v == '0' || v == '1' }
}


#[cfg(test)]
mod test_binary_char {
	use super::BinaryChar;
	use super::PrefixChar;
	#[test]
	fn test_can_output() {
		let gen = BinaryChar::new();
		assert!(gen.can_output('0'));
		assert!(gen.can_output('1'));
	}
	#[test]
	fn test_generate() {
		let gen = BinaryChar::new();
		for i in 0..64 { assert!(gen.can_output(gen.generate())); }
	}
}

pub(crate) struct Base64Char;

impl Base64Char { pub fn new() -> Self { Base64Char } }

pub static BASE64: &'static str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+=";

impl PrefixChar for Base64Char {
	fn generate(&self) -> char {
		let i = (random::<f32>() * (BASE64.len() - 1) as f32).round() as usize;
		BASE64[i..].chars().next().unwrap()
	}
	fn can_output(&self, v: char) -> bool { BASE64.contains(&format!("{}", v)) }
}


#[cfg(test)]
mod test_base64_char {
	use super::Base64Char;
	use super::PrefixChar;
	use super::BASE64;
	#[test]
	fn test_can_output() {
		let gen = Base64Char::new();
		let mut chars = BASE64.chars();
		while let Some(this_char) = chars.next() { assert!(gen.can_output(this_char)); }
	}
	#[test]
	fn test_generate() {
		let gen = Base64Char::new();
		for i in 0..256 { assert!(gen.can_output(gen.generate())); }
	}
}

pub(crate) struct Prefix ( Vec<Box<dyn PrefixChar>> );

impl Prefix {
	pub fn new() -> Self { Prefix ( Vec::new() ) }
	pub fn new_from(pattern: &String) -> Self {
		let mut to_return = Prefix::new();
		{
			let mut chars = pattern.chars();
			while let Some(this_char) = chars.next() {
				match this_char {
					'd' => { to_return.push(Box::new(DecimalChar::new())); }
					'b' => { to_return.push(Box::new(BinaryChar::new())); }
					'B' => { to_return.push(Box::new(Base64Char::new())); }
					e => { panic!(format!("Invalid suffix pattern character \"{}\". This should have been caught earlier on.", e)); }
				}
			}
		}
		to_return
	}
	pub fn push(&mut self, v: Box<dyn PrefixChar>) { self.0.push(v); }
	pub fn generate(&self) -> String {
		let mut to_return = String::new();
		for this_char in self.0.iter() { to_return.push(this_char.generate()); }
		to_return
	}
	pub fn can_output(&self, v: &String) -> bool {
		if v.len() != self.0.len() { return false; }
		let mut chars = v.chars();
		let mut i = 0;
		while let Some(this_char) = chars.next() {
			if !self.0[i].can_output(this_char) { return false; }
			i += 1;
		}
		true
	}
}

#[cfg(test)]
mod test_prefix {
	use super::Prefix;
	#[test]
	fn test_can_output() {
		{
			let prefix = Prefix::new_from(&String::from("dddd"));
			assert!(prefix.can_output(&String::from("0000")));
			assert!(prefix.can_output(&String::from("0099")));
			assert!(prefix.can_output(&String::from("9900")));
			assert_eq!(prefix.can_output(&String::from("aaaa")), false);
		}
		{
			let prefix = Prefix::new_from(&String::from("bbbb"));
			assert!(prefix.can_output(&String::from("0000")));
			assert!(prefix.can_output(&String::from("1111")));
			assert_eq!(prefix.can_output(&String::from("0002")), false);
		}
		{
			let prefix = Prefix::new_from(&String::from("BBBB"));
			assert!(prefix.can_output(&String::from("abcd")));
			assert!(prefix.can_output(&String::from("efgh")));
			assert!(prefix.can_output(&String::from("ijkl")));
			assert!(prefix.can_output(&String::from("mnop")));
			assert!(prefix.can_output(&String::from("qrst")));
			assert!(prefix.can_output(&String::from("vwxy")));
			assert!(prefix.can_output(&String::from("zABC")));
			assert!(prefix.can_output(&String::from("DEFG")));
			assert!(prefix.can_output(&String::from("HIJK")));
			assert!(prefix.can_output(&String::from("LMNO")));
			assert!(prefix.can_output(&String::from("PQRS")));
			assert!(prefix.can_output(&String::from("TUVW")));
			assert!(prefix.can_output(&String::from("XY+=")));
		}
	}
	#[test]
	fn test_generate() {
		let prefix = Prefix::new_from(&String::from("dbB"));
		for i in 0..512 { assert!(prefix.can_output(&prefix.generate())); }
	}
}
