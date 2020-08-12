pub(crate) extern crate clml_rs;
pub(crate) extern crate rand;
pub(crate) extern crate regex;

pub(crate) mod help;
pub(crate) mod add;
pub(crate) mod rem;
pub(crate) mod prefix;
pub(crate) mod _mod;

use std::env::{ args };
use std::process::{ exit };

use clml_rs::{ clml };
use regex::{ Regex };

use help::help;
use add::add;
use rem::rem;
use _mod::_mod;

fn main() {
	let args: Vec<String> = args().collect();
	if args.len() >= 2 {
		if args.len() == 3 {
			match args[1].as_str() {
				"help" => { println!("Help does not accept arguments!"); help(); exit(2); }
				"add" => {
					let regexp = Regex::new(r#"[dbB]+"#).unwrap();
					if !regexp.is_match(&args[2]) {
						println!("{}",
							clml(&format!("<red>Error:<reset> The passed prefix \"{prefix}\" does not match the RegEx \"[dbB]+\".",
								prefix = &args[2])));
						help();
						exit(6);
					} else {
						add(Some(args[2].clone()));
						exit(0);
					}
				}
				"rem" => {
					let regexp = Regex::new(r#"[dbB]+"#).unwrap();
					if !regexp.is_match(&args[2]) {
						println!("{}",
							clml(&format!("<red>Error:<reset> The passed prefix \"{prefix}\" does not match the RegEx \"[dbB]+\".",
								prefix = &args[2])));
						help();
						exit(6);
					} else {
						rem(Some(args[2].clone()));
						exit(0);
					}
				}
				"mod" => {
					let regexp = Regex::new(r#"[dbB]+"#).unwrap();
					if !regexp.is_match(&args[2]) {
						println!("{}",
							clml(&format!("<red>Error:<reset> The passed prefix \"{prefix}\" does not match the RegEx \"[dbB]+\".",
								prefix = &args[2])));
						help();
						exit(6);
					} else {
						_mod(Some(args[2].clone()));
						exit(0);
					}
				}
				_ => {}
			}
		} else if args.len() == 2 {
			match args[1].as_str() {
				"help" => { help(); exit(0); }
				"add" => { add(None); exit(0); }
				"rem" => { rem(None); exit(0); }
				"mod" => { _mod(None); exit(0); }
				invalid => {
					println!("\"{}\" is not a valid COMMAND.",
						invalid);
				}
			}
		}
	} else {
		println!("Not enough arguments.");
		help();
		exit(1);
	}
}

