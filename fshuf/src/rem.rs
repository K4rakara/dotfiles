use crate::clml_rs;

use crate::prefix;

use std::fs;
use std::path::{ Path };
use std::env::{ current_dir };
use std::process::{ exit };

use clml_rs::{ clml };

use prefix::Prefix;

pub(crate) fn rem(prefix: Option<String>) {
	let pwd = match current_dir() {
		Ok(v) => v,
		Err(e) => {
			println!("{}",
				clml(&format!("<red>Error:<reset> Failed to get the current directory. Details:\n{err}",
					err = e)));
			exit(1);
		}
	};
	let using_fshuf_file;
	let prefix_string = match prefix {
		Some(v) => {
			if pwd.join(".fshuf").exists() {
				using_fshuf_file = true;
				match fs::read_to_string(pwd.join(".fshuf")) {
					Ok(v2) => {
						if v != v2 {
							println!("{}",
								clml(&format!("<yellow>Warning:<reset> The passed pattern \"{passed}\" and the stored pattern \"{stored}\" do not match.",
									passed = v,
									stored = v2)))
						}
						v
					}
					Err(e) => {
						println!("{}",
							clml(&format!("<red>Error:<reset> Failed to read the .fshuf file in the pwd, even though it exists. Details:\n{err}",
								err = e)));
						exit(1);
					}
				}
			} else {
				using_fshuf_file = false;
				v
			}
		}
		None => {
			if pwd.join(".fshuf").exists() {
				using_fshuf_file = true;
				match fs::read_to_string(pwd.join(".fshuf")) {
					Ok(v) => v,
					Err(e) => {
						println!("{}",
							clml(&format!("<red>Error:<reset> Failed to read the .fshuf file in the pwd, even though it exists. Details:\n{err}",
								err = e)));
						exit(1);
					}
				}
			} else {
				using_fshuf_file = false;
				String::from("dddd")
			}
		}
	};
	let prefix = Prefix::new_from(&prefix_string);
	match fs::read_dir(&pwd) {
		Ok(entries) => {
			for try_entry in entries {
				match try_entry {
					Ok(entry) => {
						match entry.path().file_name() {
							Some(file_name) => {
								// Create a string from the file name.
								let file_name_string = String::from(file_name.to_string_lossy());
								if &file_name_string != ".fshuf" {
									// Make sure the file name is at least the length of the prefix.
									if file_name_string.len() >= prefix_string.len() {
										// Gets a slice of `file_name_string` based on the length of `prefix_string`.
										let file_prefix = String::from(&file_name_string[0..(prefix_string.len())]);
										// Create a copy of `file_prefix`, but with a dash appended on it for code simplicity.
										let file_prefix_dashed = format!("{}-", file_prefix);
										// Check that the `Prefix` can output `file_prefix`.
										if prefix.can_output(&file_prefix) {
											// Generate the `new_file_name` by stripping the prefix of of `file_name_string`.
											let new_file_name = String::from(&file_name_string[file_prefix_dashed.len()..]);
											// Try to rename the file to `new_file_name`, and handle errors if they occur.
											let try_rename = fs::rename(&file_name, Path::new(&new_file_name));
											if try_rename.is_err() {
												println!("{}",
													clml(&format!("<yellow>Warning:<reset> Failed to rename \"{from}\" to \"{to}\".",
														from = &file_name_string,
														to = &new_file_name)));
											}
										} else {
											println!("{}",
												clml(&format!("<yellow>Warning:<reset> The current prefix \"{prefix}\" cannot output \"{output}\", which was found as the prefix for \"{file}\".",
													prefix = &prefix_string,
													output = &file_prefix,
													file = &file_name_string)));
										}
									} else {
										println!("{}",
											clml(&format!("<yellow>Warning:<reset> The file \"{file}\" is shorter than the passed prefix \"{prefix}\".",
												file = &file_name_string,
												prefix = &prefix_string)));
									}	
								}
							}
							None => (),
						}
					}
					Err(e) => {
						println!("{}",
							clml(&format!("<yellow>Waring:<reset> The following I/O error occured:\n{err}",
								err = e)));
					}
				} 
			}
		}
		Err(e) => {
			println!("{}",
				clml(&format!("<red>Error:<reset> An uncatchable I/O error occured. Details:\n{err}",
					err = e)));
			exit(1);
		}
	}
	if using_fshuf_file { match fs::remove_file(pwd.join(".fshuf")) { Ok(_) => (), Err(_) => (), }; }
}
