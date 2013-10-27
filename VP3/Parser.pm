####################################################################
#
#    This file was generated using Parse::Yapp version 1.05.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package VP3::Parser;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
use Parse::Yapp::Driver;

#line 1 "verilog.yapp"


    use VP3::Lexer;
    use VP3::ParseTree;

    # Shortcut to VP3::ParseTree::factory for use in semantic actions
    *f = \&VP3::ParseTree::factory;

    sub null { f ("null"); }

    sub list
    {
        $_[0]->append_children ($_[1]);
        # returns $_[0]
    }

    sub list_delim
    {
        $_[2]->prepend_text ($_[1]);
        $_[0]->append_children ($_[2]);
        # returns $_[0]
    }

    sub scope
    {
        if ($_[1]) {
            $_[0]->YYData->{scope} = $_[1];
        } else {
            $_[0]->YYData->{scope};
        }
    }

    sub decl
    {
        my ($self, $obj) = @_;
        $obj->can ("decls") or VP3::fatal ("Don't know how to add object of type " . $obj->type . " to symbol table");
        my %decls = $obj->decls;
        while (my ($k, $v) = each %decls) {
            $self->scope->symtab->insert ($k => $v);
        }
        $obj;
    }

    sub binop
    {
        $_[4]->prepend_text ($_[3]);
        f ("binary_operator_expression", @_[1,2,4]);
    }

    sub drive_strength
    {
        $_[2]->prepend_text ($_[1]);
        $_[2]->append_text ($_[3]);
        $_[4]->append_text ($_[5]);
        f ("drive_strength", @_[2,4]);
    }

    sub charge_strength
    {
        $_[2]->prepend_text ($_[1]);
        $_[2]->append_text ($_[3]);
        f ("charge_strength", $_[2]);
    }

    sub default_yyerror
    {

        my ($p) = @_;

        $p->YYData->{error} = "Parse error at " . $p->YYCurtok . " on line " . $p->YYCurval->line;
        $p->YYAbort;

    };



sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.05',
                                  yystates =>
[
	{#State 0
		ACTIONS => {
			'VP3_PARSE_MODE_SOURCE_TEXT' => 1,
			'VP3_PARSE_MODE_MODULE_ITEMS' => 3,
			'VP3_PARSE_MODE_MODULE_HEADER' => 4,
			'VP3_PARSE_MODE_EXPRESSION' => 5
		},
		GOTOS => {
			'vp3_parse_start' => 2
		}
	},
	{#State 1
		ACTIONS => {
			"primitive" => 14,
			"(*" => 18,
			"\@Module" => 6,
			'EOF' => -27
		},
		DEFAULT => -572,
		GOTOS => {
			'description' => 9,
			'module_declaration' => 8,
			'attr' => 7,
			'source_text' => 11,
			'udp_declaration' => 10,
			'module_preamble' => 12,
			'traditional_module_header' => 13,
			'descriptions' => 17,
			'vp3_module_directive' => 15,
			'module_none_declaration' => 16,
			'noport_module_header' => 19,
			'v2k_module_header' => 20
		}
	},
	{#State 2
		ACTIONS => {
			'' => 21
		}
	},
	{#State 3
		ACTIONS => {
			"\@Regs" => 27,
			"\@Input" => 30,
			'EOF' => -69,
			"\@Wires" => 33,
			"\@Waive" => 39,
			"\@Ports" => 40,
			"specify" => 42,
			"(*" => 18,
			"\@Instance" => 35,
			"generate" => 45,
			"\@Vector" => 46,
			"\@Output" => 47
		},
		DEFAULT => -572,
		GOTOS => {
			'vp3_ports_directive' => 23,
			'vp3_vector_directive' => 22,
			'module_or_generate_item' => 26,
			'specify_block' => 25,
			'vp3_regs_directive' => 24,
			'vp3_module_item' => 28,
			'port_declaration' => 29,
			'attr' => 31,
			'non_port_module_item' => 32,
			'vp3_wires_directive' => 34,
			'module_items' => 37,
			'module_item' => 36,
			'vp3_instance_directive' => 38,
			'vp3_waive_directive' => 41,
			'vp3_force_directive' => 43,
			'generated_instantiation' => 44,
			'opt_module_items' => 48
		}
	},
	{#State 4
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'module_preamble' => 51,
			'traditional_module_header' => 49,
			'attr' => 7,
			'v2k_module_header' => 50
		}
	},
	{#State 5
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"~^" => 83,
			"&" => 82,
			"{" => 81,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 59,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 6
		ACTIONS => {
			'vp3_directive_text' => 90
		},
		DEFAULT => -611,
		GOTOS => {
			'vp3_directive_text_items' => 89,
			'opt_vp3_directive_text_items' => 88
		}
	},
	{#State 7
		ACTIONS => {
			"macromodule" => 92,
			"module" => 91
		},
		GOTOS => {
			'module_keyword' => 93
		}
	},
	{#State 8
		DEFAULT => -32
	},
	{#State 9
		DEFAULT => -30
	},
	{#State 10
		DEFAULT => -33
	},
	{#State 11
		ACTIONS => {
			'EOF' => 94
		}
	},
	{#State 12
		ACTIONS => {
			"(" => 95,
			";" => 96
		}
	},
	{#State 13
		ACTIONS => {
			"\@Regs" => 27,
			"\@Input" => 30,
			"\@Wires" => 33,
			"\@Waive" => 39,
			"\@Ports" => 40,
			"specify" => 42,
			"(*" => 18,
			"endmodule" => -69,
			"\@Instance" => 35,
			"generate" => 45,
			"\@Vector" => 46,
			"\@Output" => 47
		},
		DEFAULT => -572,
		GOTOS => {
			'vp3_vector_directive' => 22,
			'vp3_ports_directive' => 23,
			'module_or_generate_item' => 26,
			'specify_block' => 25,
			'vp3_regs_directive' => 24,
			'vp3_module_item' => 28,
			'port_declaration' => 29,
			'attr' => 31,
			'non_port_module_item' => 32,
			'vp3_wires_directive' => 34,
			'module_items' => 37,
			'module_item' => 36,
			'vp3_instance_directive' => 38,
			'vp3_waive_directive' => 41,
			'vp3_force_directive' => 43,
			'generated_instantiation' => 44,
			'opt_module_items' => 97
		}
	},
	{#State 14
		ACTIONS => {
			"endprimitive" => 98
		}
	},
	{#State 15
		ACTIONS => {
			'VP3_PARSE_MODE_MODULE_NONE' => -44
		},
		DEFAULT => -42,
		GOTOS => {
			'@3-1' => 99,
			'@2-1' => 100
		}
	},
	{#State 16
		DEFAULT => -28
	},
	{#State 17
		ACTIONS => {
			"primitive" => 14,
			"(*" => 18,
			"\@Module" => 6,
			'EOF' => -29
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 7,
			'description' => 102,
			'module_declaration' => 8,
			'udp_declaration' => 10,
			'module_preamble' => 12,
			'traditional_module_header' => 13,
			'vp3_module_directive' => 101,
			'noport_module_header' => 19,
			'v2k_module_header' => 20
		}
	},
	{#State 18
		ACTIONS => {
			'IDENTIFIER' => 103
		},
		GOTOS => {
			'attr_specs' => 105,
			'attr_spec' => 104,
			'attr_name' => 106
		}
	},
	{#State 19
		ACTIONS => {
			"\@Regs" => 27,
			"\@Input" => 30,
			"\@Wires" => 33,
			"\@Waive" => 39,
			"\@Ports" => 40,
			"specify" => 42,
			"(*" => 18,
			"endmodule" => -92,
			"\@Instance" => 35,
			"generate" => 45,
			"\@Vector" => 46,
			"\@Output" => 47
		},
		DEFAULT => -572,
		GOTOS => {
			'vp3_instance_directive' => 38,
			'vp3_vector_directive' => 22,
			'vp3_ports_directive' => 23,
			'module_or_generate_item' => 26,
			'specify_block' => 25,
			'vp3_regs_directive' => 24,
			'vp3_module_item' => 28,
			'vp3_waive_directive' => 41,
			'vp3_force_directive' => 43,
			'non_port_module_items' => 108,
			'attr' => 109,
			'generated_instantiation' => 44,
			'non_port_module_item' => 110,
			'vp3_wires_directive' => 34,
			'opt_non_port_module_items' => 107
		}
	},
	{#State 20
		ACTIONS => {
			"\@Regs" => 27,
			"\@Input" => 30,
			"\@Wires" => 33,
			"\@Waive" => 39,
			"\@Ports" => 40,
			"specify" => 42,
			"(*" => 18,
			"endmodule" => -92,
			"\@Instance" => 35,
			"generate" => 45,
			"\@Vector" => 46,
			"\@Output" => 47
		},
		DEFAULT => -572,
		GOTOS => {
			'vp3_instance_directive' => 38,
			'vp3_vector_directive' => 22,
			'vp3_ports_directive' => 23,
			'module_or_generate_item' => 26,
			'specify_block' => 25,
			'vp3_regs_directive' => 24,
			'vp3_module_item' => 28,
			'vp3_waive_directive' => 41,
			'vp3_force_directive' => 43,
			'non_port_module_items' => 108,
			'attr' => 109,
			'generated_instantiation' => 44,
			'non_port_module_item' => 110,
			'vp3_wires_directive' => 34,
			'opt_non_port_module_items' => 111
		}
	},
	{#State 21
		DEFAULT => 0
	},
	{#State 22
		DEFAULT => -617
	},
	{#State 23
		DEFAULT => -614
	},
	{#State 24
		DEFAULT => -616
	},
	{#State 25
		DEFAULT => -97
	},
	{#State 26
		DEFAULT => -96
	},
	{#State 27
		ACTIONS => {
			";" => 112
		}
	},
	{#State 28
		DEFAULT => -81
	},
	{#State 29
		ACTIONS => {
			";" => 113
		}
	},
	{#State 30
		ACTIONS => {
			'IDENTIFIER' => 114
		}
	},
	{#State 31
		ACTIONS => {
			"realtime" => 136,
			"tri0" => 115,
			"reg" => 140,
			"initial" => 139,
			"task" => 143,
			"wand" => 145,
			"parameter" => 148,
			"inout" => 147,
			"output" => 150,
			"localparam" => 151,
			"function" => 118,
			"tri" => 119,
			"supply1" => 152,
			"triand" => 120,
			"wor" => 121,
			'IDENTIFIER' => 123,
			"trireg" => 156,
			"wire" => 155,
			"always" => 154,
			"tri1" => 124,
			"real" => 157,
			"genvar" => 159,
			"specparam" => 162,
			"trior" => 161,
			"defparam" => 164,
			"event" => 165,
			"assign" => 166,
			"input" => 133,
			"time" => 167,
			"integer" => 134,
			"supply0" => 168
		},
		GOTOS => {
			'specparam_declaration' => 135,
			'parameter_override' => 138,
			'net_declaration' => 137,
			'reg_declaration' => 142,
			'genvar_declaration' => 141,
			'module_or_generate_item_declaration' => 144,
			'always_construct' => 146,
			'output_declaration' => 149,
			'module_identifier' => 116,
			'continuous_assign' => 117,
			'input_declaration' => 153,
			'realtime_declaration' => 122,
			'net_type' => 125,
			'event_declaration' => 126,
			'module_instantiation' => 158,
			'pds_parameter_declaration' => 160,
			'time_declaration' => 127,
			'local_parameter_declaration' => 128,
			'initial_construct' => 163,
			'function_declaration' => 129,
			'task_declaration' => 130,
			'real_declaration' => 131,
			'integer_declaration' => 132,
			'inout_declaration' => 169
		}
	},
	{#State 32
		DEFAULT => -74
	},
	{#State 33
		ACTIONS => {
			";" => 170
		}
	},
	{#State 34
		DEFAULT => -615
	},
	{#State 35
		ACTIONS => {
			'vp3_directive_text' => 90
		},
		GOTOS => {
			'vp3_directive_text_items' => 171
		}
	},
	{#State 36
		DEFAULT => -71
	},
	{#State 37
		ACTIONS => {
			"\@Regs" => 27,
			"\@Input" => 30,
			'EOF' => -70,
			"\@Wires" => 33,
			"\@Waive" => 39,
			"\@Ports" => 40,
			"specify" => 42,
			"(*" => 18,
			"endmodule" => -70,
			"\@Instance" => 35,
			"generate" => 45,
			"\@Vector" => 46,
			"\@Output" => 47
		},
		DEFAULT => -572,
		GOTOS => {
			'vp3_instance_directive' => 38,
			'vp3_vector_directive' => 22,
			'vp3_ports_directive' => 23,
			'module_or_generate_item' => 26,
			'specify_block' => 25,
			'vp3_regs_directive' => 24,
			'vp3_module_item' => 28,
			'vp3_waive_directive' => 41,
			'vp3_force_directive' => 43,
			'port_declaration' => 29,
			'attr' => 31,
			'generated_instantiation' => 44,
			'non_port_module_item' => 32,
			'vp3_wires_directive' => 34,
			'module_item' => 172
		}
	},
	{#State 38
		DEFAULT => -620
	},
	{#State 39
		ACTIONS => {
			'IDENTIFIER' => 173
		}
	},
	{#State 40
		ACTIONS => {
			";" => 174
		}
	},
	{#State 41
		DEFAULT => -619
	},
	{#State 42
		ACTIONS => {
			'opt_specify_items' => 175
		}
	},
	{#State 43
		DEFAULT => -618
	},
	{#State 44
		DEFAULT => -98
	},
	{#State 45
		ACTIONS => {
			"endgenerate" => -366,
			"\@Regs" => 27,
			"\@Input" => 30,
			"\@Wires" => 33,
			"\@Waive" => 39,
			"\@Ports" => 40,
			"for" => 179,
			"case" => 182,
			"(*" => 18,
			"begin" => 183,
			"if" => 187,
			"\@Instance" => 35,
			"\@Vector" => 46,
			"\@Output" => 47
		},
		DEFAULT => -572,
		GOTOS => {
			'vp3_vector_directive' => 22,
			'opt_generate_items' => 176,
			'vp3_ports_directive' => 23,
			'module_or_generate_item' => 177,
			'vp3_regs_directive' => 24,
			'generate_case_statement' => 184,
			'vp3_module_item' => 28,
			'attr' => 185,
			'generate_loop_statement' => 186,
			'vp3_wires_directive' => 34,
			'generate_items' => 178,
			'generate_block' => 188,
			'vp3_instance_directive' => 38,
			'vp3_waive_directive' => 41,
			'vp3_force_directive' => 43,
			'generate_conditional_statement' => 180,
			'generate_item' => 181
		}
	},
	{#State 46
		ACTIONS => {
			"-" => 52,
			"+" => 72,
			"~" => 54,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"[" => 190,
			'IDENTIFIER' => 62,
			"~^" => 83,
			"&" => 82,
			"{" => 81,
			'BASED_NUMBER' => 64,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'range' => 191,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 189,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'constant_expression' => 192,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 47
		ACTIONS => {
			'IDENTIFIER' => 193
		}
	},
	{#State 48
		ACTIONS => {
			'EOF' => 194
		}
	},
	{#State 49
		ACTIONS => {
			'EOF' => 195
		}
	},
	{#State 50
		ACTIONS => {
			'EOF' => 196
		}
	},
	{#State 51
		ACTIONS => {
			"(" => 95
		}
	},
	{#State 52
		DEFAULT => -549
	},
	{#State 53
		DEFAULT => -541
	},
	{#State 54
		DEFAULT => -551
	},
	{#State 55
		DEFAULT => -495
	},
	{#State 56
		DEFAULT => -496
	},
	{#State 57
		DEFAULT => -601
	},
	{#State 58
		DEFAULT => -550
	},
	{#State 59
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			'EOF' => 202,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		}
	},
	{#State 60
		DEFAULT => -587
	},
	{#State 61
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 224
		}
	},
	{#State 62
		ACTIONS => {
			"." => 225
		},
		DEFAULT => -590
	},
	{#State 63
		DEFAULT => -562
	},
	{#State 64
		DEFAULT => -560
	},
	{#State 65
		ACTIONS => {
			"[" => 226,
			"(" => -585,
			"(*" => -585
		},
		DEFAULT => -536,
		GOTOS => {
			'subscripts' => 227,
			'bracket_expression' => 228,
			'bracket_expressions' => 229
		}
	},
	{#State 66
		DEFAULT => -540
	},
	{#State 67
		DEFAULT => -554
	},
	{#State 68
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'mintypmax_expression' => 231,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 230,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 69
		DEFAULT => -493
	},
	{#State 70
		DEFAULT => -494
	},
	{#State 71
		DEFAULT => -535
	},
	{#State 72
		DEFAULT => -548
	},
	{#State 73
		DEFAULT => -492
	},
	{#State 74
		DEFAULT => -555
	},
	{#State 75
		DEFAULT => -539
	},
	{#State 76
		DEFAULT => -571
	},
	{#State 77
		DEFAULT => -556
	},
	{#State 78
		ACTIONS => {
			'IDENTIFIER' => 233
		},
		GOTOS => {
			'hierarchical_identifier_piece' => 232
		}
	},
	{#State 79
		ACTIONS => {
			"(" => 234
		},
		DEFAULT => -1,
		GOTOS => {
			'opt_arguments' => 235
		}
	},
	{#State 80
		DEFAULT => -538
	},
	{#State 81
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expressions' => 237,
			'expression' => 236,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 82
		DEFAULT => -552
	},
	{#State 83
		DEFAULT => -557
	},
	{#State 84
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 238
		}
	},
	{#State 85
		ACTIONS => {
			'BASED_NUMBER' => 240,
			"." => 241,
			"E" => 242,
			"e" => 243
		},
		DEFAULT => -559,
		GOTOS => {
			'exp' => 239
		}
	},
	{#State 86
		DEFAULT => -558
	},
	{#State 87
		DEFAULT => -553
	},
	{#State 88
		ACTIONS => {
			";" => 244
		}
	},
	{#State 89
		ACTIONS => {
			'vp3_directive_text' => 245
		},
		DEFAULT => -610
	},
	{#State 90
		DEFAULT => -612
	},
	{#State 91
		DEFAULT => -46
	},
	{#State 92
		DEFAULT => -47
	},
	{#State 93
		ACTIONS => {
			'IDENTIFIER' => 123
		},
		GOTOS => {
			'module_identifier' => 246
		}
	},
	{#State 94
		DEFAULT => -605
	},
	{#State 95
		ACTIONS => {
			'IDENTIFIER' => 250,
			"(*" => 18,
			")" => 254
		},
		DEFAULT => -572,
		GOTOS => {
			'list_of_port_declarations' => 247,
			'pic_port_declaration' => 252,
			'pip_port_declaration' => 251,
			'pic_port_declarations' => 255,
			'list_of_port_identifiers' => 248,
			'attr' => 253,
			'port_identifier' => 249
		}
	},
	{#State 96
		DEFAULT => -36
	},
	{#State 97
		ACTIONS => {
			"endmodule" => 256
		}
	},
	{#State 98
		DEFAULT => -391
	},
	{#State 99
		ACTIONS => {
			'VP3_PARSE_MODE_MODULE_NONE' => 257
		}
	},
	{#State 100
		ACTIONS => {
			"\@Regs" => 27,
			"\@Input" => 30,
			"\@Wires" => 33,
			"\@Waive" => 39,
			"\@Ports" => 40,
			"specify" => 42,
			"(*" => 18,
			"endmodule" => -69,
			"\@Instance" => 35,
			"generate" => 45,
			"\@Vector" => 46,
			"\@Output" => 47
		},
		DEFAULT => -572,
		GOTOS => {
			'vp3_vector_directive' => 22,
			'vp3_ports_directive' => 23,
			'module_or_generate_item' => 26,
			'specify_block' => 25,
			'vp3_regs_directive' => 24,
			'vp3_module_item' => 28,
			'port_declaration' => 29,
			'attr' => 31,
			'non_port_module_item' => 32,
			'vp3_wires_directive' => 34,
			'module_items' => 37,
			'module_item' => 36,
			'vp3_instance_directive' => 38,
			'vp3_waive_directive' => 41,
			'vp3_force_directive' => 43,
			'generated_instantiation' => 44,
			'opt_module_items' => 258
		}
	},
	{#State 101
		DEFAULT => -42,
		GOTOS => {
			'@2-1' => 100
		}
	},
	{#State 102
		DEFAULT => -31
	},
	{#State 103
		DEFAULT => -578
	},
	{#State 104
		DEFAULT => -574
	},
	{#State 105
		ACTIONS => {
			"," => 260,
			"*)" => 259
		}
	},
	{#State 106
		ACTIONS => {
			"=" => 261
		},
		DEFAULT => -577
	},
	{#State 107
		ACTIONS => {
			"endmodule" => 262
		}
	},
	{#State 108
		ACTIONS => {
			"\@Regs" => 27,
			"\@Input" => 30,
			"\@Wires" => 33,
			"\@Waive" => 39,
			"\@Ports" => 40,
			"specify" => 42,
			"(*" => 18,
			"endmodule" => -93,
			"\@Instance" => 35,
			"generate" => 45,
			"\@Vector" => 46,
			"\@Output" => 47
		},
		DEFAULT => -572,
		GOTOS => {
			'vp3_instance_directive' => 38,
			'vp3_vector_directive' => 22,
			'vp3_ports_directive' => 23,
			'module_or_generate_item' => 26,
			'specify_block' => 25,
			'vp3_regs_directive' => 24,
			'vp3_module_item' => 28,
			'vp3_waive_directive' => 41,
			'vp3_force_directive' => 43,
			'attr' => 109,
			'generated_instantiation' => 44,
			'non_port_module_item' => 263,
			'vp3_wires_directive' => 34
		}
	},
	{#State 109
		ACTIONS => {
			"realtime" => 136,
			"tri0" => 115,
			"reg" => 140,
			"initial" => 139,
			"task" => 143,
			"wand" => 145,
			"parameter" => 148,
			"localparam" => 151,
			"function" => 118,
			"tri" => 119,
			"supply1" => 152,
			"triand" => 120,
			"wor" => 121,
			'IDENTIFIER' => 123,
			"trireg" => 156,
			"wire" => 155,
			"always" => 154,
			"tri1" => 124,
			"real" => 157,
			"genvar" => 159,
			"specparam" => 162,
			"trior" => 161,
			"defparam" => 164,
			"event" => 165,
			"assign" => 166,
			"time" => 167,
			"integer" => 134,
			"supply0" => 168
		},
		GOTOS => {
			'specparam_declaration' => 135,
			'parameter_override' => 138,
			'net_declaration' => 137,
			'reg_declaration' => 142,
			'genvar_declaration' => 141,
			'module_or_generate_item_declaration' => 144,
			'always_construct' => 146,
			'module_identifier' => 116,
			'continuous_assign' => 117,
			'realtime_declaration' => 122,
			'net_type' => 125,
			'event_declaration' => 126,
			'module_instantiation' => 158,
			'pds_parameter_declaration' => 160,
			'time_declaration' => 127,
			'local_parameter_declaration' => 128,
			'initial_construct' => 163,
			'function_declaration' => 129,
			'task_declaration' => 130,
			'real_declaration' => 131,
			'integer_declaration' => 132
		}
	},
	{#State 110
		DEFAULT => -94
	},
	{#State 111
		ACTIONS => {
			"endmodule" => 264
		}
	},
	{#State 112
		DEFAULT => -623
	},
	{#State 113
		DEFAULT => -73
	},
	{#State 114
		ACTIONS => {
			";" => 265
		}
	},
	{#State 115
		DEFAULT => -174
	},
	{#State 116
		ACTIONS => {
			"#" => 268
		},
		DEFAULT => -339,
		GOTOS => {
			'parameter_value_assignment' => 266,
			'opt_parameter_value_assignment' => 267
		}
	},
	{#State 117
		DEFAULT => -77
	},
	{#State 118
		ACTIONS => {
			"automatic" => 270
		},
		DEFAULT => -7,
		GOTOS => {
			'opt_automatic' => 269
		}
	},
	{#State 119
		DEFAULT => -171
	},
	{#State 120
		DEFAULT => -172
	},
	{#State 121
		DEFAULT => -178
	},
	{#State 122
		DEFAULT => -87
	},
	{#State 123
		DEFAULT => -594
	},
	{#State 124
		DEFAULT => -175
	},
	{#State 125
		ACTIONS => {
			"vectored" => 271,
			"signed" => 276,
			"(" => 272,
			"scalared" => 273
		},
		DEFAULT => -5,
		GOTOS => {
			'drive_strength' => 275,
			'opt_signed' => 274,
			'vectored_or_scalared' => 277
		}
	},
	{#State 126
		DEFAULT => -88
	},
	{#State 127
		DEFAULT => -86
	},
	{#State 128
		DEFAULT => -99
	},
	{#State 129
		DEFAULT => -91
	},
	{#State 130
		DEFAULT => -90
	},
	{#State 131
		DEFAULT => -85
	},
	{#State 132
		DEFAULT => -84
	},
	{#State 133
		ACTIONS => {
			"wor" => 121,
			"signed" => 276,
			"wire" => 155,
			"tri1" => 124,
			"tri0" => 115,
			"wand" => 145,
			"trior" => 161,
			"tri" => 119,
			"supply1" => 152,
			"supply0" => 168,
			"triand" => 120
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 279,
			'net_type' => 278,
			'input_type' => 280
		}
	},
	{#State 134
		ACTIONS => {
			'IDENTIFIER' => 284
		},
		GOTOS => {
			'variable_type' => 283,
			'list_of_variable_identifiers' => 282,
			'variable_identifier' => 281
		}
	},
	{#State 135
		DEFAULT => -101
	},
	{#State 136
		ACTIONS => {
			'IDENTIFIER' => 286
		},
		GOTOS => {
			'real_type' => 288,
			'real_identifier' => 287,
			'list_of_real_identifiers' => 285
		}
	},
	{#State 137
		DEFAULT => -82
	},
	{#State 138
		DEFAULT => -76
	},
	{#State 139
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statement' => 289,
			'attr' => 290
		}
	},
	{#State 140
		ACTIONS => {
			"signed" => 276
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 291
		}
	},
	{#State 141
		DEFAULT => -89
	},
	{#State 142
		DEFAULT => -83
	},
	{#State 143
		ACTIONS => {
			"automatic" => 270
		},
		DEFAULT => -7,
		GOTOS => {
			'opt_automatic' => 292
		}
	},
	{#State 144
		DEFAULT => -75
	},
	{#State 145
		DEFAULT => -177
	},
	{#State 146
		DEFAULT => -80
	},
	{#State 147
		ACTIONS => {
			"wor" => 121,
			"signed" => 276,
			"wire" => 155,
			"tri1" => 124,
			"tri0" => 115,
			"wand" => 145,
			"trior" => 161,
			"tri" => 119,
			"supply1" => 152,
			"supply0" => 168,
			"triand" => 120
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 279,
			'net_type' => 278,
			'input_type' => 293
		}
	},
	{#State 148
		ACTIONS => {
			"signed" => 276,
			"realtime" => 297,
			"time" => 299,
			"integer" => 295,
			"real" => 298
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 296,
			'parameter_type' => 294
		}
	},
	{#State 149
		DEFAULT => -68
	},
	{#State 150
		ACTIONS => {
			"tri0" => 115,
			"reg" => 303,
			"wand" => 145,
			"tri" => 119,
			"supply1" => 152,
			"triand" => 120,
			"wor" => 121,
			"tri1" => 124,
			"wire" => 155,
			"signed" => 276,
			"trior" => 161,
			"integer" => 301,
			"time" => 306,
			"supply0" => 168
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 302,
			'output_net_type' => 304,
			'net_type' => 300,
			'output_var_type' => 305
		}
	},
	{#State 151
		ACTIONS => {
			"signed" => 276,
			"realtime" => 297,
			"time" => 299,
			"integer" => 295,
			"real" => 298
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 308,
			'parameter_type' => 307
		}
	},
	{#State 152
		DEFAULT => -170
	},
	{#State 153
		DEFAULT => -67
	},
	{#State 154
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statement' => 309,
			'attr' => 290
		}
	},
	{#State 155
		DEFAULT => -176
	},
	{#State 156
		ACTIONS => {
			"vectored" => 271,
			"signed" => 276,
			"(" => 310,
			"scalared" => 273
		},
		DEFAULT => -5,
		GOTOS => {
			'drive_strength' => 313,
			'opt_signed' => 311,
			'vectored_or_scalared' => 314,
			'charge_strength' => 312
		}
	},
	{#State 157
		ACTIONS => {
			'IDENTIFIER' => 286
		},
		GOTOS => {
			'real_type' => 288,
			'real_identifier' => 287,
			'list_of_real_identifiers' => 315
		}
	},
	{#State 158
		DEFAULT => -78
	},
	{#State 159
		ACTIONS => {
			'IDENTIFIER' => 317
		},
		GOTOS => {
			'list_of_genvar_identifiers' => 316,
			'genvar_identifier' => 318
		}
	},
	{#State 160
		DEFAULT => -100
	},
	{#State 161
		DEFAULT => -173
	},
	{#State 162
		ACTIONS => {
			"[" => 190
		},
		DEFAULT => -262,
		GOTOS => {
			'range' => 320,
			'opt_range' => 319
		}
	},
	{#State 163
		DEFAULT => -79
	},
	{#State 164
		ACTIONS => {
			'IDENTIFIER' => 62
		},
		GOTOS => {
			'hierarchical_parameter_identifier' => 322,
			'defparam_assignment' => 323,
			'hierarchical_identifier_piece' => 60,
			'list_of_defparam_assignments' => 324,
			'hierarchical_identifier_pieces' => 78,
			'hierarchical_identifier' => 321
		}
	},
	{#State 165
		ACTIONS => {
			'IDENTIFIER' => 325
		},
		GOTOS => {
			'event_identifier' => 328,
			'list_of_event_identifiers' => 327,
			'event_identifier_dimensions' => 326
		}
	},
	{#State 166
		ACTIONS => {
			"(" => 272
		},
		DEFAULT => -185,
		GOTOS => {
			'drive_strength' => 330,
			'opt_drive_strength' => 329
		}
	},
	{#State 167
		ACTIONS => {
			'IDENTIFIER' => 284
		},
		GOTOS => {
			'variable_type' => 283,
			'list_of_variable_identifiers' => 331,
			'variable_identifier' => 281
		}
	},
	{#State 168
		DEFAULT => -169
	},
	{#State 169
		DEFAULT => -66
	},
	{#State 170
		DEFAULT => -622
	},
	{#State 171
		ACTIONS => {
			";" => 332,
			'vp3_directive_text' => 245
		}
	},
	{#State 172
		DEFAULT => -72
	},
	{#State 173
		ACTIONS => {
			'IDENTIFIER' => 333
		}
	},
	{#State 174
		DEFAULT => -621
	},
	{#State 175
		ACTIONS => {
			"endspecify" => 334
		}
	},
	{#State 176
		ACTIONS => {
			"endgenerate" => 335
		}
	},
	{#State 177
		DEFAULT => -374
	},
	{#State 178
		ACTIONS => {
			"endgenerate" => -367,
			"\@Regs" => 27,
			"\@Input" => 30,
			"\@Wires" => 33,
			"\@Waive" => 39,
			"\@Ports" => 40,
			"for" => 179,
			"case" => 182,
			"(*" => 18,
			"begin" => 183,
			"if" => 187,
			"end" => -367,
			"\@Instance" => 35,
			"\@Vector" => 46,
			"\@Output" => 47
		},
		DEFAULT => -572,
		GOTOS => {
			'vp3_instance_directive' => 38,
			'vp3_vector_directive' => 22,
			'vp3_ports_directive' => 23,
			'module_or_generate_item' => 177,
			'vp3_regs_directive' => 24,
			'generate_case_statement' => 184,
			'vp3_module_item' => 28,
			'vp3_waive_directive' => 41,
			'vp3_force_directive' => 43,
			'attr' => 185,
			'generate_loop_statement' => 186,
			'generate_conditional_statement' => 180,
			'vp3_wires_directive' => 34,
			'generate_item' => 336,
			'generate_block' => 188
		}
	},
	{#State 179
		ACTIONS => {
			"(" => 337
		}
	},
	{#State 180
		DEFAULT => -370
	},
	{#State 181
		DEFAULT => -368
	},
	{#State 182
		ACTIONS => {
			"(" => 338
		}
	},
	{#State 183
		ACTIONS => {
			":" => 339
		},
		DEFAULT => -389,
		GOTOS => {
			'opt_generate_block_identifier' => 340
		}
	},
	{#State 184
		DEFAULT => -371
	},
	{#State 185
		ACTIONS => {
			"realtime" => 136,
			"tri0" => 115,
			"reg" => 140,
			"initial" => 139,
			"task" => 143,
			"wand" => 145,
			"function" => 118,
			"tri" => 119,
			"supply1" => 152,
			"triand" => 120,
			"wor" => 121,
			'IDENTIFIER' => 123,
			"trireg" => 156,
			"tri1" => 124,
			"always" => 154,
			"wire" => 155,
			"real" => 157,
			"genvar" => 159,
			"trior" => 161,
			"defparam" => 164,
			"event" => 165,
			"assign" => 166,
			"time" => 167,
			"integer" => 134,
			"supply0" => 168
		},
		GOTOS => {
			'realtime_declaration' => 122,
			'parameter_override' => 138,
			'net_declaration' => 137,
			'net_type' => 125,
			'reg_declaration' => 142,
			'genvar_declaration' => 141,
			'event_declaration' => 126,
			'module_or_generate_item_declaration' => 144,
			'module_instantiation' => 158,
			'time_declaration' => 127,
			'always_construct' => 146,
			'initial_construct' => 163,
			'integer_declaration' => 132,
			'real_declaration' => 131,
			'module_identifier' => 116,
			'function_declaration' => 129,
			'task_declaration' => 130,
			'continuous_assign' => 117
		}
	},
	{#State 186
		DEFAULT => -372
	},
	{#State 187
		ACTIONS => {
			"(" => 341
		}
	},
	{#State 188
		DEFAULT => -373
	},
	{#State 189
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"%" => 199,
			"==" => 200,
			">=" => 201,
			"*" => 203,
			">>" => 204,
			"||" => 205,
			"!==" => 206,
			"|" => 207,
			"<=" => 208,
			">" => 209,
			"**" => 210,
			"+" => 211,
			"<<<" => 212,
			"^" => 213,
			"!=" => 214,
			"&&" => 215,
			"?" => 216,
			"~^" => 217,
			"&" => 218,
			"===" => 219,
			"/" => 220,
			">>>" => 221,
			"<<" => 222,
			"^~" => 223
		},
		DEFAULT => -487
	},
	{#State 190
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'msb_constant_expression' => 342,
			'expression' => 189,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'constant_expression' => 343,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 191
		ACTIONS => {
			'IDENTIFIER' => 344
		}
	},
	{#State 192
		ACTIONS => {
			'IDENTIFIER' => 345
		}
	},
	{#State 193
		ACTIONS => {
			";" => 346
		}
	},
	{#State 194
		DEFAULT => -606
	},
	{#State 195
		DEFAULT => -607
	},
	{#State 196
		DEFAULT => -608
	},
	{#State 197
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 347
		}
	},
	{#State 198
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 348
		}
	},
	{#State 199
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 349
		}
	},
	{#State 200
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 350
		}
	},
	{#State 201
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 351
		}
	},
	{#State 202
		DEFAULT => -609
	},
	{#State 203
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 352
		}
	},
	{#State 204
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 353
		}
	},
	{#State 205
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 354
		}
	},
	{#State 206
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 355
		}
	},
	{#State 207
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 356
		}
	},
	{#State 208
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 357
		}
	},
	{#State 209
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 358
		}
	},
	{#State 210
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 359
		}
	},
	{#State 211
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 360
		}
	},
	{#State 212
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 361
		}
	},
	{#State 213
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 362
		}
	},
	{#State 214
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 363
		}
	},
	{#State 215
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 364
		}
	},
	{#State 216
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 365
		}
	},
	{#State 217
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 366
		}
	},
	{#State 218
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 367
		}
	},
	{#State 219
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 368
		}
	},
	{#State 220
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 369
		}
	},
	{#State 221
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 370
		}
	},
	{#State 222
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 371
		}
	},
	{#State 223
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'attr' => 372
		}
	},
	{#State 224
		ACTIONS => {
			"(" => 68,
			'IDENTIFIER' => 62,
			'UNSIGNED_NUMBER' => 85,
			"{" => 81,
			'BASED_NUMBER' => 64,
			'SYSTEM_IDENTIFIER' => 57
		},
		GOTOS => {
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 373,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'multiple_concatenation' => 75,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'hierarchical_identifier_piece' => 60,
			'hierarchical_identifier_pieces' => 78
		}
	},
	{#State 225
		DEFAULT => -586
	},
	{#State 226
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'base_expression' => 377,
			'multiple_concatenation' => 75,
			'msb_constant_expression' => 374,
			'expression' => 375,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'constant_expression' => 343,
			'concatenation' => 80,
			'real_number' => 63,
			'range_expression_colon' => 376,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 227
		DEFAULT => -537
	},
	{#State 228
		DEFAULT => -14
	},
	{#State 229
		ACTIONS => {
			"[" => 378
		},
		DEFAULT => -16,
		GOTOS => {
			'bracket_expression' => 379
		}
	},
	{#State 230
		ACTIONS => {
			"-" => 197,
			":" => 380,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		},
		DEFAULT => -526
	},
	{#State 231
		ACTIONS => {
			")" => 381
		}
	},
	{#State 232
		DEFAULT => -588
	},
	{#State 233
		ACTIONS => {
			"." => 225
		},
		DEFAULT => -589
	},
	{#State 234
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expressions' => 383,
			'expression' => 382,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 235
		DEFAULT => -484
	},
	{#State 236
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"{" => 385,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		},
		DEFAULT => -490,
		GOTOS => {
			'concatenation' => 384
		}
	},
	{#State 237
		ACTIONS => {
			"}" => 386,
			"," => 387
		}
	},
	{#State 238
		ACTIONS => {
			"(" => 388
		}
	},
	{#State 239
		ACTIONS => {
			"-" => 389,
			"+" => 391
		},
		DEFAULT => -568,
		GOTOS => {
			'opt_sign' => 390
		}
	},
	{#State 240
		DEFAULT => -561
	},
	{#State 241
		ACTIONS => {
			'UNSIGNED_NUMBER' => 392
		}
	},
	{#State 242
		DEFAULT => -567
	},
	{#State 243
		DEFAULT => -566
	},
	{#State 244
		DEFAULT => -624
	},
	{#State 245
		DEFAULT => -613
	},
	{#State 246
		DEFAULT => -34,
		GOTOS => {
			'@1-3' => 393
		}
	},
	{#State 247
		ACTIONS => {
			";" => 394
		}
	},
	{#State 248
		ACTIONS => {
			"," => 395,
			")" => 396
		}
	},
	{#State 249
		DEFAULT => -234
	},
	{#State 250
		DEFAULT => -598
	},
	{#State 251
		DEFAULT => -56
	},
	{#State 252
		DEFAULT => -61
	},
	{#State 253
		ACTIONS => {
			"inout" => 402,
			"output" => 403,
			"input" => 399
		},
		GOTOS => {
			'pip_output_declaration' => 397,
			'pic_input_declaration' => 401,
			'pic_inout_declaration' => 398,
			'pip_inout_declaration' => 400,
			'pic_output_declaration' => 405,
			'pip_input_declaration' => 404
		}
	},
	{#State 254
		DEFAULT => -55
	},
	{#State 255
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'pic_port_declaration' => 407,
			'pip_port_declaration' => 406,
			'attr' => 253
		}
	},
	{#State 256
		DEFAULT => -39
	},
	{#State 257
		ACTIONS => {
			"\@Regs" => 27,
			"\@Input" => 30,
			'EOF' => -69,
			"\@Wires" => 33,
			"\@Waive" => 39,
			"\@Ports" => 40,
			"specify" => 42,
			"(*" => 18,
			"\@Instance" => 35,
			"generate" => 45,
			"\@Vector" => 46,
			"\@Output" => 47
		},
		DEFAULT => -572,
		GOTOS => {
			'vp3_vector_directive' => 22,
			'vp3_ports_directive' => 23,
			'module_or_generate_item' => 26,
			'specify_block' => 25,
			'vp3_regs_directive' => 24,
			'vp3_module_item' => 28,
			'port_declaration' => 29,
			'attr' => 31,
			'non_port_module_item' => 32,
			'vp3_wires_directive' => 34,
			'module_items' => 37,
			'module_item' => 36,
			'vp3_instance_directive' => 38,
			'vp3_waive_directive' => 41,
			'vp3_force_directive' => 43,
			'generated_instantiation' => 44,
			'opt_module_items' => 408
		}
	},
	{#State 258
		ACTIONS => {
			"endmodule" => 409
		}
	},
	{#State 259
		DEFAULT => -573
	},
	{#State 260
		ACTIONS => {
			'IDENTIFIER' => 103
		},
		GOTOS => {
			'attr_spec' => 410,
			'attr_name' => 106
		}
	},
	{#State 261
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 189,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'constant_expression' => 411,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 262
		DEFAULT => -41
	},
	{#State 263
		DEFAULT => -95
	},
	{#State 264
		DEFAULT => -40
	},
	{#State 265
		DEFAULT => -628
	},
	{#State 266
		DEFAULT => -340
	},
	{#State 267
		ACTIONS => {
			'IDENTIFIER' => 412
		},
		GOTOS => {
			'module_instance' => 416,
			'module_instance_identifier' => 415,
			'module_instances' => 414,
			'name_of_instance' => 413
		}
	},
	{#State 268
		ACTIONS => {
			"(" => 417
		}
	},
	{#State 269
		ACTIONS => {
			"signed" => 276
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 418
		}
	},
	{#State 270
		DEFAULT => -8
	},
	{#State 271
		DEFAULT => -142
	},
	{#State 272
		ACTIONS => {
			"weak0" => 428,
			"highz0" => 419,
			"weak1" => 429,
			"strong0" => 420,
			"strong1" => 424,
			"pull0" => 425,
			"highz1" => 422,
			"pull1" => 426,
			"supply1" => 427,
			"supply0" => 430
		},
		GOTOS => {
			'strength0' => 423,
			'strength1' => 421
		}
	},
	{#State 273
		DEFAULT => -143
	},
	{#State 274
		ACTIONS => {
			"#" => 434,
			"[" => 190
		},
		DEFAULT => -204,
		GOTOS => {
			'opt_delay3' => 431,
			'delay3' => 433,
			'range' => 432
		}
	},
	{#State 275
		ACTIONS => {
			"vectored" => 271,
			"signed" => 276,
			"scalared" => 273
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 435,
			'vectored_or_scalared' => 436
		}
	},
	{#State 276
		DEFAULT => -6
	},
	{#State 277
		ACTIONS => {
			"signed" => 276
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 437
		}
	},
	{#State 278
		ACTIONS => {
			"signed" => 276
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 438
		}
	},
	{#State 279
		ACTIONS => {
			"[" => 190
		},
		DEFAULT => -262,
		GOTOS => {
			'range' => 320,
			'opt_range' => 439
		}
	},
	{#State 280
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		GOTOS => {
			'list_of_port_identifiers' => 440,
			'port_identifier' => 249
		}
	},
	{#State 281
		ACTIONS => {
			"[" => 443,
			"=" => 445
		},
		DEFAULT => -179,
		GOTOS => {
			'dimension' => 442,
			'opt_constant_assignment' => 444,
			'dimensions' => 441
		}
	},
	{#State 282
		ACTIONS => {
			";" => 446,
			"," => 447
		}
	},
	{#State 283
		DEFAULT => -240
	},
	{#State 284
		DEFAULT => -604
	},
	{#State 285
		ACTIONS => {
			";" => 448,
			"," => 449
		}
	},
	{#State 286
		DEFAULT => -599
	},
	{#State 287
		ACTIONS => {
			"[" => 443,
			"=" => 445
		},
		DEFAULT => -179,
		GOTOS => {
			'dimension' => 442,
			'opt_constant_assignment' => 451,
			'dimensions' => 450
		}
	},
	{#State 288
		DEFAULT => -236
	},
	{#State 289
		DEFAULT => -397
	},
	{#State 290
		ACTIONS => {
			"begin" => 472,
			"\@" => 453,
			"forever" => 473,
			"wait" => 475,
			'SYSTEM_IDENTIFIER' => 455,
			"if" => 476,
			"deassign" => 479,
			"disable" => 481,
			'IDENTIFIER' => 62,
			"{" => 483,
			"->" => 461,
			"while" => 485,
			"casex" => 486,
			"for" => 463,
			"force" => 490,
			"#" => 489,
			"release" => 467,
			"case" => 466,
			"assign" => 493,
			"fork" => 492,
			"casez" => 470,
			"repeat" => 494
		},
		GOTOS => {
			'conditional_statement' => 471,
			'seq_block' => 452,
			'procedural_timing_control' => 454,
			'nonblocking_assignment' => 474,
			'event_trigger' => 456,
			'hierarchical_task_identifier' => 477,
			'blocking_assignment' => 478,
			'delay_control' => 457,
			'event_control' => 480,
			'hierarchical_identifier_piece' => 60,
			'procedural_timing_control_statement' => 458,
			'hierarchical_identifier_pieces' => 78,
			'par_block' => 459,
			'lvalue' => 482,
			'case_statement' => 484,
			'hierarchical_identifier' => 460,
			'disable_statement' => 462,
			'wait_statement' => 487,
			'task_enable' => 464,
			'case_token' => 488,
			'procedural_continuous_assignment' => 465,
			'system_task_enable' => 491,
			'loop_statement' => 468,
			'system_task_identifier' => 469
		}
	},
	{#State 291
		ACTIONS => {
			"[" => 190
		},
		DEFAULT => -262,
		GOTOS => {
			'range' => 320,
			'opt_range' => 495
		}
	},
	{#State 292
		ACTIONS => {
			'IDENTIFIER' => 496
		},
		GOTOS => {
			'task_identifier' => 497
		}
	},
	{#State 293
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		GOTOS => {
			'list_of_port_identifiers' => 498,
			'port_identifier' => 249
		}
	},
	{#State 294
		ACTIONS => {
			'IDENTIFIER' => 501
		},
		GOTOS => {
			'pas_param_assignments' => 500,
			'parameter_identifier' => 503,
			'pac_param_assignment' => 499,
			'pac_param_assignments' => 502,
			'param_assignment' => 504,
			'pas_param_assignment' => 505
		}
	},
	{#State 295
		DEFAULT => -112
	},
	{#State 296
		ACTIONS => {
			"[" => 190
		},
		DEFAULT => -262,
		GOTOS => {
			'range' => 320,
			'opt_range' => 506
		}
	},
	{#State 297
		DEFAULT => -114
	},
	{#State 298
		DEFAULT => -113
	},
	{#State 299
		DEFAULT => -115
	},
	{#State 300
		ACTIONS => {
			"signed" => 276
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 507
		}
	},
	{#State 301
		DEFAULT => -129
	},
	{#State 302
		ACTIONS => {
			"[" => 190
		},
		DEFAULT => -262,
		GOTOS => {
			'range' => 320,
			'opt_range' => 508
		}
	},
	{#State 303
		ACTIONS => {
			"signed" => 276
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 509
		}
	},
	{#State 304
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		GOTOS => {
			'list_of_port_identifiers' => 510,
			'port_identifier' => 249
		}
	},
	{#State 305
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		GOTOS => {
			'list_of_variable_port_identifiers' => 513,
			'variable_port_identifier' => 512,
			'port_identifier' => 511
		}
	},
	{#State 306
		DEFAULT => -130
	},
	{#State 307
		ACTIONS => {
			'IDENTIFIER' => 501
		},
		GOTOS => {
			'pas_param_assignments' => 514,
			'parameter_identifier' => 503,
			'pac_param_assignment' => 499,
			'pac_param_assignments' => 502,
			'param_assignment' => 504,
			'pas_param_assignment' => 505
		}
	},
	{#State 308
		ACTIONS => {
			"[" => 190
		},
		DEFAULT => -262,
		GOTOS => {
			'range' => 320,
			'opt_range' => 515
		}
	},
	{#State 309
		DEFAULT => -398
	},
	{#State 310
		ACTIONS => {
			"weak0" => 428,
			"highz0" => 419,
			"weak1" => 429,
			"strong0" => 420,
			"large" => 516,
			"strong1" => 424,
			"small" => 517,
			"pull0" => 425,
			"medium" => 518,
			"highz1" => 422,
			"pull1" => 426,
			"supply1" => 427,
			"supply0" => 430
		},
		GOTOS => {
			'strength0' => 423,
			'strength1' => 421
		}
	},
	{#State 311
		ACTIONS => {
			"#" => 434,
			"[" => 190
		},
		DEFAULT => -204,
		GOTOS => {
			'opt_delay3' => 519,
			'delay3' => 433,
			'range' => 520
		}
	},
	{#State 312
		ACTIONS => {
			"vectored" => 271,
			"signed" => 276,
			"scalared" => 273
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 521,
			'vectored_or_scalared' => 522
		}
	},
	{#State 313
		ACTIONS => {
			"vectored" => 271,
			"signed" => 276,
			"scalared" => 273
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 523,
			'vectored_or_scalared' => 524
		}
	},
	{#State 314
		ACTIONS => {
			"signed" => 276
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 525
		}
	},
	{#State 315
		ACTIONS => {
			";" => 526,
			"," => 449
		}
	},
	{#State 316
		ACTIONS => {
			";" => 527,
			"," => 528
		}
	},
	{#State 317
		DEFAULT => -583
	},
	{#State 318
		DEFAULT => -218
	},
	{#State 319
		ACTIONS => {
			'IDENTIFIER' => 530,
			"PATHPULSE\$" => 534
		},
		GOTOS => {
			'pulse_control_specparam' => 529,
			'list_of_specparam_assignments' => 533,
			'specparam_assignment' => 532,
			'specparam_identifier' => 531
		}
	},
	{#State 320
		DEFAULT => -263
	},
	{#State 321
		DEFAULT => -591
	},
	{#State 322
		ACTIONS => {
			"=" => 535
		}
	},
	{#State 323
		DEFAULT => -213
	},
	{#State 324
		ACTIONS => {
			";" => 536,
			"," => 537
		}
	},
	{#State 325
		DEFAULT => -580
	},
	{#State 326
		DEFAULT => -216
	},
	{#State 327
		ACTIONS => {
			";" => 538,
			"," => 539
		}
	},
	{#State 328
		ACTIONS => {
			"[" => 443
		},
		DEFAULT => -257,
		GOTOS => {
			'opt_dimensions' => 541,
			'dimension' => 442,
			'dimensions' => 540
		}
	},
	{#State 329
		ACTIONS => {
			"#" => 434
		},
		DEFAULT => -204,
		GOTOS => {
			'opt_delay3' => 542,
			'delay3' => 433
		}
	},
	{#State 330
		DEFAULT => -186
	},
	{#State 331
		ACTIONS => {
			";" => 543,
			"," => 447
		}
	},
	{#State 332
		DEFAULT => -625
	},
	{#State 333
		ACTIONS => {
			";" => 544
		}
	},
	{#State 334
		DEFAULT => -476
	},
	{#State 335
		DEFAULT => -363
	},
	{#State 336
		DEFAULT => -369
	},
	{#State 337
		ACTIONS => {
			'IDENTIFIER' => 317
		},
		GOTOS => {
			'genvar_assignment' => 545,
			'genvar_identifier' => 546
		}
	},
	{#State 338
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 189,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'constant_expression' => 547,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 339
		ACTIONS => {
			'IDENTIFIER' => 548
		},
		GOTOS => {
			'generate_block_identifier' => 549
		}
	},
	{#State 340
		ACTIONS => {
			"\@Regs" => 27,
			"\@Input" => 30,
			"\@Wires" => 33,
			"\@Waive" => 39,
			"\@Ports" => 40,
			"for" => 179,
			"case" => 182,
			"(*" => 18,
			"begin" => 183,
			"if" => 187,
			"end" => -366,
			"\@Instance" => 35,
			"\@Vector" => 46,
			"\@Output" => 47
		},
		DEFAULT => -572,
		GOTOS => {
			'vp3_vector_directive' => 22,
			'opt_generate_items' => 550,
			'vp3_ports_directive' => 23,
			'module_or_generate_item' => 177,
			'vp3_regs_directive' => 24,
			'generate_case_statement' => 184,
			'vp3_module_item' => 28,
			'attr' => 185,
			'generate_loop_statement' => 186,
			'vp3_wires_directive' => 34,
			'generate_items' => 178,
			'generate_block' => 188,
			'vp3_instance_directive' => 38,
			'vp3_waive_directive' => 41,
			'vp3_force_directive' => 43,
			'generate_conditional_statement' => 180,
			'generate_item' => 181
		}
	},
	{#State 341
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 189,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'constant_expression' => 551,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 342
		ACTIONS => {
			":" => 552
		}
	},
	{#State 343
		DEFAULT => -528
	},
	{#State 344
		ACTIONS => {
			";" => 553
		}
	},
	{#State 345
		ACTIONS => {
			";" => 554
		}
	},
	{#State 346
		DEFAULT => -629
	},
	{#State 347
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 555,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 348
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 556,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 349
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 557,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 350
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 558,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 351
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 559,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 352
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 560,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 353
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 561,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 354
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 562,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 355
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 563,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 356
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 564,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 357
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 565,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 358
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 566,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 359
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 567,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 360
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 568,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 361
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 569,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 362
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 570,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 363
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 571,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 364
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 572,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 365
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 573,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 366
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 574,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 367
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 575,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 368
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 576,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 369
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 577,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 370
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 578,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 371
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 579,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 372
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 580,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 373
		DEFAULT => -497
	},
	{#State 374
		ACTIONS => {
			":" => 581
		}
	},
	{#State 375
		ACTIONS => {
			":" => -487,
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			"]" => 582,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		},
		DEFAULT => -485
	},
	{#State 376
		ACTIONS => {
			"]" => 583
		}
	},
	{#State 377
		ACTIONS => {
			"-:" => 585,
			"+:" => 584
		}
	},
	{#State 378
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'base_expression' => 377,
			'multiple_concatenation' => 75,
			'msb_constant_expression' => 374,
			'expression' => 375,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'constant_expression' => 343,
			'concatenation' => 80,
			'real_number' => 63,
			'range_expression_colon' => 586,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 379
		DEFAULT => -15
	},
	{#State 380
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 587,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 381
		DEFAULT => -542
	},
	{#State 382
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		},
		DEFAULT => -490
	},
	{#State 383
		ACTIONS => {
			"," => 387,
			")" => 588
		}
	},
	{#State 384
		ACTIONS => {
			"}" => 589
		}
	},
	{#State 385
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expressions' => 237,
			'expression' => 382,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 386
		DEFAULT => -481
	},
	{#State 387
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 590,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 388
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expressions' => 591,
			'expression' => 382,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 389
		DEFAULT => -570
	},
	{#State 390
		ACTIONS => {
			'UNSIGNED_NUMBER' => 592
		}
	},
	{#State 391
		DEFAULT => -569
	},
	{#State 392
		ACTIONS => {
			"E" => 242,
			"e" => 243
		},
		DEFAULT => -563,
		GOTOS => {
			'exp' => 593
		}
	},
	{#State 393
		ACTIONS => {
			"#" => 596
		},
		DEFAULT => -52,
		GOTOS => {
			'opt_module_parameter_port_list' => 595,
			'module_parameter_port_list' => 594
		}
	},
	{#State 394
		DEFAULT => -38
	},
	{#State 395
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		GOTOS => {
			'port_identifier' => 597
		}
	},
	{#State 396
		ACTIONS => {
			";" => 598
		}
	},
	{#State 397
		DEFAULT => -60
	},
	{#State 398
		DEFAULT => -63
	},
	{#State 399
		ACTIONS => {
			"wor" => 121,
			"signed" => 276,
			"wire" => 155,
			"tri1" => 124,
			"tri0" => 115,
			"wand" => 145,
			"trior" => 161,
			"tri" => 119,
			"supply1" => 152,
			"supply0" => 168,
			"triand" => 120
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 279,
			'net_type' => 278,
			'input_type' => 599
		}
	},
	{#State 400
		DEFAULT => -58
	},
	{#State 401
		DEFAULT => -64
	},
	{#State 402
		ACTIONS => {
			"wor" => 121,
			"signed" => 276,
			"wire" => 155,
			"tri1" => 124,
			"tri0" => 115,
			"wand" => 145,
			"trior" => 161,
			"tri" => 119,
			"supply1" => 152,
			"supply0" => 168,
			"triand" => 120
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 279,
			'net_type' => 278,
			'input_type' => 600
		}
	},
	{#State 403
		ACTIONS => {
			"tri0" => 115,
			"reg" => 303,
			"wand" => 145,
			"tri" => 119,
			"supply1" => 152,
			"triand" => 120,
			"wor" => 121,
			"tri1" => 124,
			"wire" => 155,
			"signed" => 276,
			"trior" => 161,
			"integer" => 301,
			"time" => 306,
			"supply0" => 168
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 302,
			'output_net_type' => 601,
			'net_type' => 300,
			'output_var_type' => 602
		}
	},
	{#State 404
		DEFAULT => -59
	},
	{#State 405
		DEFAULT => -65
	},
	{#State 406
		DEFAULT => -57
	},
	{#State 407
		DEFAULT => -62
	},
	{#State 408
		DEFAULT => -45
	},
	{#State 409
		DEFAULT => -43
	},
	{#State 410
		DEFAULT => -575
	},
	{#State 411
		DEFAULT => -576
	},
	{#State 412
		DEFAULT => -595
	},
	{#State 413
		ACTIONS => {
			"(" => 603
		}
	},
	{#State 414
		ACTIONS => {
			";" => 604,
			"," => 605
		}
	},
	{#State 415
		ACTIONS => {
			"[" => 190
		},
		DEFAULT => -262,
		GOTOS => {
			'range' => 320,
			'opt_range' => 606
		}
	},
	{#State 416
		DEFAULT => -348
	},
	{#State 417
		ACTIONS => {
			"-" => 52,
			"+" => 72,
			"~" => 54,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			'IDENTIFIER' => 62,
			"~^" => 83,
			"&" => 82,
			"{" => 81,
			'BASED_NUMBER' => 64,
			"(" => 68,
			"|" => 67,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"." => 609,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expressions' => 610,
			'expression' => 382,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'list_of_parameter_assignments' => 611,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'named_parameter_assignment' => 607,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'ordered_parameter_assignments' => 612,
			'unary_operator_expression' => 69,
			'named_parameter_assignments' => 608
		}
	},
	{#State 418
		ACTIONS => {
			"realtime" => 615,
			"[" => 190,
			"time" => 619,
			"integer" => 614,
			"real" => 618
		},
		DEFAULT => -278,
		GOTOS => {
			'opt_range_or_type' => 617,
			'range' => 616,
			'range_or_type' => 613
		}
	},
	{#State 419
		ACTIONS => {
			"," => 620
		}
	},
	{#State 420
		DEFAULT => -194
	},
	{#State 421
		ACTIONS => {
			"," => 621
		}
	},
	{#State 422
		ACTIONS => {
			"," => 622
		}
	},
	{#State 423
		ACTIONS => {
			"," => 623
		}
	},
	{#State 424
		DEFAULT => -198
	},
	{#State 425
		DEFAULT => -195
	},
	{#State 426
		DEFAULT => -199
	},
	{#State 427
		DEFAULT => -197
	},
	{#State 428
		DEFAULT => -196
	},
	{#State 429
		DEFAULT => -200
	},
	{#State 430
		DEFAULT => -193
	},
	{#State 431
		ACTIONS => {
			'IDENTIFIER' => 625
		},
		GOTOS => {
			'list_of_net_decl_assignments' => 624,
			'list_of_net_identifiers' => 626,
			'net_identifier' => 629,
			'net_identifier_dimensions' => 627,
			'net_decl_assignment' => 628
		}
	},
	{#State 432
		ACTIONS => {
			"#" => 434
		},
		DEFAULT => -204,
		GOTOS => {
			'opt_delay3' => 630,
			'delay3' => 433
		}
	},
	{#State 433
		DEFAULT => -205
	},
	{#State 434
		ACTIONS => {
			"(" => 633,
			'IDENTIFIER' => 631,
			'UNSIGNED_NUMBER' => 635
		},
		GOTOS => {
			'real_number' => 632,
			'delay_value' => 634
		}
	},
	{#State 435
		ACTIONS => {
			"#" => 434,
			"[" => 190
		},
		DEFAULT => -204,
		GOTOS => {
			'opt_delay3' => 636,
			'delay3' => 433,
			'range' => 637
		}
	},
	{#State 436
		ACTIONS => {
			"signed" => 276
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 638
		}
	},
	{#State 437
		ACTIONS => {
			"[" => 190
		},
		GOTOS => {
			'range' => 639
		}
	},
	{#State 438
		ACTIONS => {
			"[" => 190
		},
		DEFAULT => -262,
		GOTOS => {
			'range' => 320,
			'opt_range' => 640
		}
	},
	{#State 439
		DEFAULT => -116
	},
	{#State 440
		ACTIONS => {
			"," => 395
		},
		DEFAULT => -121
	},
	{#State 441
		ACTIONS => {
			"[" => 443
		},
		DEFAULT => -184,
		GOTOS => {
			'dimension' => 641
		}
	},
	{#State 442
		DEFAULT => -259
	},
	{#State 443
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'dimension_constant_expression' => 642,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 189,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'constant_expression' => 643,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 444
		DEFAULT => -183
	},
	{#State 445
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 189,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'constant_expression' => 644,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 446
		DEFAULT => -141
	},
	{#State 447
		ACTIONS => {
			'IDENTIFIER' => 284
		},
		GOTOS => {
			'variable_type' => 645,
			'variable_identifier' => 281
		}
	},
	{#State 448
		DEFAULT => -166
	},
	{#State 449
		ACTIONS => {
			'IDENTIFIER' => 286
		},
		GOTOS => {
			'real_type' => 646,
			'real_identifier' => 287
		}
	},
	{#State 450
		ACTIONS => {
			"[" => 443
		},
		DEFAULT => -182,
		GOTOS => {
			'dimension' => 641
		}
	},
	{#State 451
		DEFAULT => -181
	},
	{#State 452
		DEFAULT => -425
	},
	{#State 453
		ACTIONS => {
			"(" => 648,
			'IDENTIFIER' => 325,
			"*" => 647,
			"(*" => 649,
			"(*)" => 650
		},
		GOTOS => {
			'event_identifier' => 651
		}
	},
	{#State 454
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statement' => 652,
			'attr' => 653,
			'statement_or_null' => 654
		}
	},
	{#State 455
		DEFAULT => -602
	},
	{#State 456
		DEFAULT => -419
	},
	{#State 457
		DEFAULT => -454
	},
	{#State 458
		DEFAULT => -424
	},
	{#State 459
		DEFAULT => -422
	},
	{#State 460
		ACTIONS => {
			"(" => -592,
			";" => -592,
			"[" => 226
		},
		DEFAULT => -545,
		GOTOS => {
			'subscripts' => 655,
			'bracket_expression' => 228,
			'bracket_expressions' => 229
		}
	},
	{#State 461
		ACTIONS => {
			'IDENTIFIER' => 62
		},
		GOTOS => {
			'hierarchical_identifier_piece' => 60,
			'hierarchical_event_identifier' => 656,
			'hierarchical_identifier_pieces' => 78,
			'hierarchical_identifier' => 657
		}
	},
	{#State 462
		DEFAULT => -418
	},
	{#State 463
		ACTIONS => {
			"(" => 658
		}
	},
	{#State 464
		DEFAULT => -427
	},
	{#State 465
		ACTIONS => {
			";" => 659
		}
	},
	{#State 466
		DEFAULT => -461
	},
	{#State 467
		ACTIONS => {
			'IDENTIFIER' => 62,
			"{" => 483
		},
		GOTOS => {
			'lvalue' => 661,
			'hierarchical_identifier_piece' => 60,
			'hierarchical_identifier_pieces' => 78,
			'hierarchical_identifier' => 660
		}
	},
	{#State 468
		DEFAULT => -420
	},
	{#State 469
		ACTIONS => {
			"(" => 234
		},
		DEFAULT => -1,
		GOTOS => {
			'opt_arguments' => 662
		}
	},
	{#State 470
		DEFAULT => -463
	},
	{#State 471
		DEFAULT => -417
	},
	{#State 472
		ACTIONS => {
			":" => 663,
			"end" => -411,
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statements' => 666,
			'opt_statements' => 665,
			'block_identifier_and_declarations' => 667,
			'statement' => 664,
			'attr' => 290
		}
	},
	{#State 473
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statement' => 668,
			'attr' => 290
		}
	},
	{#State 474
		ACTIONS => {
			";" => 669
		}
	},
	{#State 475
		ACTIONS => {
			"(" => 670
		}
	},
	{#State 476
		ACTIONS => {
			"(" => 671
		}
	},
	{#State 477
		ACTIONS => {
			"(" => 234
		},
		DEFAULT => -1,
		GOTOS => {
			'opt_arguments' => 672
		}
	},
	{#State 478
		ACTIONS => {
			";" => 673
		}
	},
	{#State 479
		ACTIONS => {
			'IDENTIFIER' => 62,
			"{" => 483
		},
		GOTOS => {
			'lvalue' => 674,
			'hierarchical_identifier_piece' => 60,
			'hierarchical_identifier_pieces' => 78,
			'hierarchical_identifier' => 660
		}
	},
	{#State 480
		DEFAULT => -455
	},
	{#State 481
		ACTIONS => {
			'IDENTIFIER' => 62
		},
		GOTOS => {
			'hierarchical_task_or_block_identifier' => 675,
			'hierarchical_identifier_piece' => 60,
			'hierarchical_identifier_pieces' => 78,
			'hierarchical_identifier' => 676
		}
	},
	{#State 482
		ACTIONS => {
			"<=" => 677,
			"=" => 678
		}
	},
	{#State 483
		ACTIONS => {
			'IDENTIFIER' => 62,
			"{" => 483
		},
		GOTOS => {
			'lvalue' => 680,
			'hierarchical_identifier_piece' => 60,
			'hierarchical_identifier_pieces' => 78,
			'hierarchical_identifier' => 660,
			'lvalues' => 679
		}
	},
	{#State 484
		DEFAULT => -416
	},
	{#State 485
		ACTIONS => {
			"(" => 681
		}
	},
	{#State 486
		DEFAULT => -462
	},
	{#State 487
		DEFAULT => -428
	},
	{#State 488
		ACTIONS => {
			"(" => 682
		}
	},
	{#State 489
		ACTIONS => {
			"(" => 683,
			'IDENTIFIER' => 631,
			'UNSIGNED_NUMBER' => 635
		},
		GOTOS => {
			'real_number' => 632,
			'delay_value' => 684
		}
	},
	{#State 490
		ACTIONS => {
			'IDENTIFIER' => 62,
			"{" => 483
		},
		GOTOS => {
			'assignment' => 685,
			'lvalue' => 686,
			'hierarchical_identifier_piece' => 60,
			'hierarchical_identifier_pieces' => 78,
			'hierarchical_identifier' => 660
		}
	},
	{#State 491
		DEFAULT => -426
	},
	{#State 492
		ACTIONS => {
			":" => 663,
			"join" => -411,
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statements' => 666,
			'opt_statements' => 687,
			'block_identifier_and_declarations' => 688,
			'statement' => 664,
			'attr' => 290
		}
	},
	{#State 493
		ACTIONS => {
			'IDENTIFIER' => 62,
			"{" => 483
		},
		GOTOS => {
			'assignment' => 689,
			'lvalue' => 686,
			'hierarchical_identifier_piece' => 60,
			'variable_assignment' => 690,
			'hierarchical_identifier_pieces' => 78,
			'hierarchical_identifier' => 660
		}
	},
	{#State 494
		ACTIONS => {
			"(" => 691
		}
	},
	{#State 495
		ACTIONS => {
			'IDENTIFIER' => 284
		},
		GOTOS => {
			'variable_type' => 283,
			'list_of_variable_identifiers' => 692,
			'variable_identifier' => 281
		}
	},
	{#State 496
		DEFAULT => -603
	},
	{#State 497
		ACTIONS => {
			"(" => 693,
			";" => 694
		}
	},
	{#State 498
		ACTIONS => {
			"," => 395
		},
		DEFAULT => -125
	},
	{#State 499
		DEFAULT => -226
	},
	{#State 500
		DEFAULT => -110
	},
	{#State 501
		DEFAULT => -597
	},
	{#State 502
		ACTIONS => {
			'IDENTIFIER' => 501
		},
		GOTOS => {
			'parameter_identifier' => 503,
			'pac_param_assignment' => 695,
			'param_assignment' => 504,
			'pas_param_assignment' => 696
		}
	},
	{#State 503
		ACTIONS => {
			"=" => 697
		}
	},
	{#State 504
		ACTIONS => {
			";" => 698,
			"," => 699
		}
	},
	{#State 505
		DEFAULT => -232
	},
	{#State 506
		ACTIONS => {
			'IDENTIFIER' => 501
		},
		GOTOS => {
			'pas_param_assignments' => 700,
			'parameter_identifier' => 503,
			'pac_param_assignment' => 499,
			'pac_param_assignments' => 502,
			'param_assignment' => 504,
			'pas_param_assignment' => 505
		}
	},
	{#State 507
		ACTIONS => {
			"[" => 190
		},
		DEFAULT => -262,
		GOTOS => {
			'range' => 320,
			'opt_range' => 701
		}
	},
	{#State 508
		DEFAULT => -126
	},
	{#State 509
		ACTIONS => {
			"[" => 190
		},
		DEFAULT => -262,
		GOTOS => {
			'range' => 320,
			'opt_range' => 702
		}
	},
	{#State 510
		ACTIONS => {
			"," => 395
		},
		DEFAULT => -137
	},
	{#State 511
		ACTIONS => {
			"=" => 445
		},
		DEFAULT => -179,
		GOTOS => {
			'opt_constant_assignment' => 703
		}
	},
	{#State 512
		DEFAULT => -243
	},
	{#State 513
		ACTIONS => {
			"," => 704
		},
		DEFAULT => -138
	},
	{#State 514
		DEFAULT => -104
	},
	{#State 515
		ACTIONS => {
			'IDENTIFIER' => 501
		},
		GOTOS => {
			'pas_param_assignments' => 705,
			'parameter_identifier' => 503,
			'pac_param_assignment' => 499,
			'pac_param_assignments' => 502,
			'param_assignment' => 504,
			'pas_param_assignment' => 505
		}
	},
	{#State 516
		ACTIONS => {
			")" => 706
		}
	},
	{#State 517
		ACTIONS => {
			")" => 707
		}
	},
	{#State 518
		ACTIONS => {
			")" => 708
		}
	},
	{#State 519
		ACTIONS => {
			'IDENTIFIER' => 625
		},
		GOTOS => {
			'list_of_net_decl_assignments' => 709,
			'list_of_net_identifiers' => 710,
			'net_identifier' => 629,
			'net_identifier_dimensions' => 627,
			'net_decl_assignment' => 628
		}
	},
	{#State 520
		ACTIONS => {
			"#" => 434
		},
		DEFAULT => -204,
		GOTOS => {
			'opt_delay3' => 711,
			'delay3' => 433
		}
	},
	{#State 521
		ACTIONS => {
			"#" => 434,
			"[" => 190
		},
		DEFAULT => -204,
		GOTOS => {
			'opt_delay3' => 712,
			'delay3' => 433,
			'range' => 713
		}
	},
	{#State 522
		ACTIONS => {
			"signed" => 276
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 714
		}
	},
	{#State 523
		ACTIONS => {
			"#" => 434,
			"[" => 190
		},
		DEFAULT => -204,
		GOTOS => {
			'opt_delay3' => 715,
			'delay3' => 433,
			'range' => 716
		}
	},
	{#State 524
		ACTIONS => {
			"signed" => 276
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 717
		}
	},
	{#State 525
		ACTIONS => {
			"[" => 190
		},
		GOTOS => {
			'range' => 718
		}
	},
	{#State 526
		DEFAULT => -165
	},
	{#State 527
		DEFAULT => -140
	},
	{#State 528
		ACTIONS => {
			'IDENTIFIER' => 317
		},
		GOTOS => {
			'genvar_identifier' => 719
		}
	},
	{#State 529
		DEFAULT => -249
	},
	{#State 530
		DEFAULT => -600
	},
	{#State 531
		ACTIONS => {
			"=" => 720
		}
	},
	{#State 532
		DEFAULT => -238
	},
	{#State 533
		ACTIONS => {
			";" => 721,
			"," => 722
		}
	},
	{#State 534
		ACTIONS => {
			'identifier' => 723,
			"=" => 725
		},
		GOTOS => {
			'specify_input_terminal_descriptor' => 724
		}
	},
	{#State 535
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'mintypmax_expression' => 727,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 230,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'constant_mintypmax_expression' => 726,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 536
		DEFAULT => -102
	},
	{#State 537
		ACTIONS => {
			'IDENTIFIER' => 62
		},
		GOTOS => {
			'hierarchical_parameter_identifier' => 322,
			'defparam_assignment' => 728,
			'hierarchical_identifier_piece' => 60,
			'hierarchical_identifier_pieces' => 78,
			'hierarchical_identifier' => 321
		}
	},
	{#State 538
		DEFAULT => -139
	},
	{#State 539
		ACTIONS => {
			'IDENTIFIER' => 325
		},
		GOTOS => {
			'event_identifier' => 328,
			'event_identifier_dimensions' => 729
		}
	},
	{#State 540
		ACTIONS => {
			"[" => 443
		},
		DEFAULT => -258,
		GOTOS => {
			'dimension' => 641
		}
	},
	{#State 541
		DEFAULT => -215
	},
	{#State 542
		ACTIONS => {
			'IDENTIFIER' => 62,
			"{" => 483
		},
		GOTOS => {
			'assignment' => 731,
			'lvalue' => 686,
			'list_of_net_assignments' => 732,
			'hierarchical_identifier_piece' => 60,
			'hierarchical_identifier_pieces' => 78,
			'hierarchical_identifier' => 660,
			'net_assignment' => 730
		}
	},
	{#State 543
		DEFAULT => -168
	},
	{#State 544
		DEFAULT => -630
	},
	{#State 545
		ACTIONS => {
			";" => 733
		}
	},
	{#State 546
		ACTIONS => {
			"=" => 734
		}
	},
	{#State 547
		ACTIONS => {
			")" => 735
		}
	},
	{#State 548
		DEFAULT => -582
	},
	{#State 549
		DEFAULT => -390
	},
	{#State 550
		ACTIONS => {
			"end" => 736
		}
	},
	{#State 551
		ACTIONS => {
			")" => 737
		}
	},
	{#State 552
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'lsb_constant_expression' => 738,
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 189,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'constant_expression' => 739,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 553
		DEFAULT => -627
	},
	{#State 554
		DEFAULT => -626
	},
	{#State 555
		ACTIONS => {
			"%" => 199,
			"*" => 203,
			"**" => 210,
			"/" => 220
		},
		DEFAULT => -499
	},
	{#State 556
		ACTIONS => {
			"-" => 197,
			"%" => 199,
			"*" => 203,
			">>" => 204,
			"**" => 210,
			"+" => 211,
			"<<<" => 212,
			"/" => 220,
			">>>" => 221,
			"<<" => 222
		},
		DEFAULT => -510
	},
	{#State 557
		ACTIONS => {
			"**" => 210
		},
		DEFAULT => -502
	},
	{#State 558
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"%" => 199,
			">=" => 201,
			"*" => 203,
			">>" => 204,
			"<=" => 208,
			">" => 209,
			"**" => 210,
			"+" => 211,
			"<<<" => 212,
			"/" => 220,
			">>>" => 221,
			"<<" => 222
		},
		DEFAULT => -503
	},
	{#State 559
		ACTIONS => {
			"-" => 197,
			"%" => 199,
			"*" => 203,
			">>" => 204,
			"**" => 210,
			"+" => 211,
			"<<<" => 212,
			"/" => 220,
			">>>" => 221,
			"<<" => 222
		},
		DEFAULT => -513
	},
	{#State 560
		ACTIONS => {
			"**" => 210
		},
		DEFAULT => -500
	},
	{#State 561
		ACTIONS => {
			"-" => 197,
			"%" => 199,
			"*" => 203,
			"**" => 210,
			"+" => 211,
			"/" => 220
		},
		DEFAULT => -519
	},
	{#State 562
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"%" => 199,
			"==" => 200,
			">=" => 201,
			"*" => 203,
			">>" => 204,
			"!==" => 206,
			"|" => 207,
			"<=" => 208,
			">" => 209,
			"**" => 210,
			"+" => 211,
			"<<<" => 212,
			"^" => 213,
			"!=" => 214,
			"&&" => 215,
			"~^" => 217,
			"&" => 218,
			"===" => 219,
			"/" => 220,
			">>>" => 221,
			"<<" => 222,
			"^~" => 223
		},
		DEFAULT => -508
	},
	{#State 563
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"%" => 199,
			">=" => 201,
			"*" => 203,
			">>" => 204,
			"<=" => 208,
			">" => 209,
			"**" => 210,
			"+" => 211,
			"<<<" => 212,
			"/" => 220,
			">>>" => 221,
			"<<" => 222
		},
		DEFAULT => -506
	},
	{#State 564
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"%" => 199,
			"==" => 200,
			">=" => 201,
			"*" => 203,
			">>" => 204,
			"!==" => 206,
			"<=" => 208,
			">" => 209,
			"**" => 210,
			"+" => 211,
			"<<<" => 212,
			"^" => 213,
			"!=" => 214,
			"~^" => 217,
			"&" => 218,
			"===" => 219,
			"/" => 220,
			">>>" => 221,
			"<<" => 222,
			"^~" => 223
		},
		DEFAULT => -515
	},
	{#State 565
		ACTIONS => {
			"-" => 197,
			"%" => 199,
			"*" => 203,
			">>" => 204,
			"**" => 210,
			"+" => 211,
			"<<<" => 212,
			"/" => 220,
			">>>" => 221,
			"<<" => 222
		},
		DEFAULT => -511
	},
	{#State 566
		ACTIONS => {
			"-" => 197,
			"%" => 199,
			"*" => 203,
			">>" => 204,
			"**" => 210,
			"+" => 211,
			"<<<" => 212,
			"/" => 220,
			">>>" => 221,
			"<<" => 222
		},
		DEFAULT => -512
	},
	{#State 567
		DEFAULT => -509
	},
	{#State 568
		ACTIONS => {
			"%" => 199,
			"*" => 203,
			"**" => 210,
			"/" => 220
		},
		DEFAULT => -498
	},
	{#State 569
		ACTIONS => {
			"-" => 197,
			"%" => 199,
			"*" => 203,
			"**" => 210,
			"+" => 211,
			"/" => 220
		},
		DEFAULT => -522
	},
	{#State 570
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"%" => 199,
			"==" => 200,
			">=" => 201,
			"*" => 203,
			">>" => 204,
			"!==" => 206,
			"<=" => 208,
			">" => 209,
			"**" => 210,
			"+" => 211,
			"<<<" => 212,
			"!=" => 214,
			"&" => 218,
			"===" => 219,
			"/" => 220,
			">>>" => 221,
			"<<" => 222
		},
		DEFAULT => -516
	},
	{#State 571
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"%" => 199,
			">=" => 201,
			"*" => 203,
			">>" => 204,
			"<=" => 208,
			">" => 209,
			"**" => 210,
			"+" => 211,
			"<<<" => 212,
			"/" => 220,
			">>>" => 221,
			"<<" => 222
		},
		DEFAULT => -504
	},
	{#State 572
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"%" => 199,
			"==" => 200,
			">=" => 201,
			"*" => 203,
			">>" => 204,
			"!==" => 206,
			"|" => 207,
			"<=" => 208,
			">" => 209,
			"**" => 210,
			"+" => 211,
			"<<<" => 212,
			"^" => 213,
			"!=" => 214,
			"~^" => 217,
			"&" => 218,
			"===" => 219,
			"/" => 220,
			">>>" => 221,
			"<<" => 222,
			"^~" => 223
		},
		DEFAULT => -507
	},
	{#State 573
		ACTIONS => {
			":" => 740,
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		}
	},
	{#State 574
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"%" => 199,
			"==" => 200,
			">=" => 201,
			"*" => 203,
			">>" => 204,
			"!==" => 206,
			"<=" => 208,
			">" => 209,
			"**" => 210,
			"+" => 211,
			"<<<" => 212,
			"!=" => 214,
			"&" => 218,
			"===" => 219,
			"/" => 220,
			">>>" => 221,
			"<<" => 222
		},
		DEFAULT => -518
	},
	{#State 575
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"%" => 199,
			"==" => 200,
			">=" => 201,
			"*" => 203,
			">>" => 204,
			"!==" => 206,
			"<=" => 208,
			">" => 209,
			"**" => 210,
			"+" => 211,
			"<<<" => 212,
			"!=" => 214,
			"===" => 219,
			"/" => 220,
			">>>" => 221,
			"<<" => 222
		},
		DEFAULT => -514
	},
	{#State 576
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"%" => 199,
			">=" => 201,
			"*" => 203,
			">>" => 204,
			"<=" => 208,
			">" => 209,
			"**" => 210,
			"+" => 211,
			"<<<" => 212,
			"/" => 220,
			">>>" => 221,
			"<<" => 222
		},
		DEFAULT => -505
	},
	{#State 577
		ACTIONS => {
			"**" => 210
		},
		DEFAULT => -501
	},
	{#State 578
		ACTIONS => {
			"-" => 197,
			"%" => 199,
			"*" => 203,
			"**" => 210,
			"+" => 211,
			"/" => 220
		},
		DEFAULT => -521
	},
	{#State 579
		ACTIONS => {
			"-" => 197,
			"%" => 199,
			"*" => 203,
			"**" => 210,
			"+" => 211,
			"/" => 220
		},
		DEFAULT => -520
	},
	{#State 580
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"%" => 199,
			"==" => 200,
			">=" => 201,
			"*" => 203,
			">>" => 204,
			"!==" => 206,
			"<=" => 208,
			">" => 209,
			"**" => 210,
			"+" => 211,
			"<<<" => 212,
			"!=" => 214,
			"&" => 218,
			"===" => 219,
			"/" => 220,
			">>>" => 221,
			"<<" => 222
		},
		DEFAULT => -517
	},
	{#State 581
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'lsb_constant_expression' => 741,
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 189,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'constant_expression' => 739,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 582
		DEFAULT => -13
	},
	{#State 583
		DEFAULT => -18
	},
	{#State 584
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 189,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'constant_expression' => 742,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69,
			'width_constant_expression' => 743
		}
	},
	{#State 585
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 189,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'constant_expression' => 742,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69,
			'width_constant_expression' => 744
		}
	},
	{#State 586
		ACTIONS => {
			"]" => 745
		}
	},
	{#State 587
		ACTIONS => {
			":" => 746,
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		}
	},
	{#State 588
		DEFAULT => -2
	},
	{#State 589
		DEFAULT => -482
	},
	{#State 590
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		},
		DEFAULT => -491
	},
	{#State 591
		ACTIONS => {
			"," => 387,
			")" => 747
		}
	},
	{#State 592
		DEFAULT => -564
	},
	{#State 593
		ACTIONS => {
			"-" => 389,
			"+" => 391
		},
		DEFAULT => -568,
		GOTOS => {
			'opt_sign' => 748
		}
	},
	{#State 594
		DEFAULT => -53
	},
	{#State 595
		DEFAULT => -35
	},
	{#State 596
		ACTIONS => {
			"(" => 749
		}
	},
	{#State 597
		DEFAULT => -235
	},
	{#State 598
		DEFAULT => -37
	},
	{#State 599
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		GOTOS => {
			'pics' => 752,
			'port_identifier' => 750,
			'pic' => 753,
			'pip' => 751
		}
	},
	{#State 600
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		GOTOS => {
			'pics' => 755,
			'port_identifier' => 750,
			'pic' => 753,
			'pip' => 754
		}
	},
	{#State 601
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		GOTOS => {
			'pics' => 757,
			'port_identifier' => 750,
			'pic' => 753,
			'pip' => 756
		}
	},
	{#State 602
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		GOTOS => {
			'vpics' => 758,
			'vpip' => 761,
			'variable_port_identifier' => 759,
			'port_identifier' => 511,
			'vpic' => 760
		}
	},
	{#State 603
		ACTIONS => {
			"-" => 52,
			"+" => 72,
			"~" => 54,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			")" => -352,
			'IDENTIFIER' => 62,
			"{" => 81,
			"~^" => 83,
			"&" => 82,
			'BASED_NUMBER' => 64,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"." => 764,
			"~&" => 87
		},
		DEFAULT => -9,
		GOTOS => {
			'binary_operator_expression' => 70,
			'opt_list_of_port_connections' => 766,
			'ordered_port_connection' => 765,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 762,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'named_port_connections' => 767,
			'opt_expression' => 768,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'list_of_port_connections' => 763,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69,
			'named_port_connection' => 769
		}
	},
	{#State 604
		DEFAULT => -338
	},
	{#State 605
		ACTIONS => {
			'IDENTIFIER' => 412
		},
		GOTOS => {
			'module_instance' => 770,
			'module_instance_identifier' => 415,
			'name_of_instance' => 413
		}
	},
	{#State 606
		DEFAULT => -351
	},
	{#State 607
		DEFAULT => -345
	},
	{#State 608
		ACTIONS => {
			"," => 771
		},
		DEFAULT => -343
	},
	{#State 609
		ACTIONS => {
			'IDENTIFIER' => 501
		},
		GOTOS => {
			'parameter_identifier' => 772
		}
	},
	{#State 610
		ACTIONS => {
			"," => 387
		},
		DEFAULT => -344
	},
	{#State 611
		ACTIONS => {
			")" => 773
		}
	},
	{#State 612
		DEFAULT => -342
	},
	{#State 613
		DEFAULT => -279
	},
	{#State 614
		DEFAULT => -281
	},
	{#State 615
		DEFAULT => -283
	},
	{#State 616
		DEFAULT => -280
	},
	{#State 617
		ACTIONS => {
			'IDENTIFIER' => 774
		},
		GOTOS => {
			'function_identifier' => 775
		}
	},
	{#State 618
		DEFAULT => -282
	},
	{#State 619
		DEFAULT => -284
	},
	{#State 620
		ACTIONS => {
			"weak1" => 429,
			"pull1" => 426,
			"supply1" => 427,
			"strong1" => 424
		},
		GOTOS => {
			'strength1' => 776
		}
	},
	{#State 621
		ACTIONS => {
			"weak0" => 428,
			"highz0" => 777,
			"strong0" => 420,
			"supply0" => 430,
			"pull0" => 425
		},
		GOTOS => {
			'strength0' => 778
		}
	},
	{#State 622
		ACTIONS => {
			"weak0" => 428,
			"strong0" => 420,
			"supply0" => 430,
			"pull0" => 425
		},
		GOTOS => {
			'strength0' => 779
		}
	},
	{#State 623
		ACTIONS => {
			"highz1" => 781,
			"weak1" => 429,
			"pull1" => 426,
			"supply1" => 427,
			"strong1" => 424
		},
		GOTOS => {
			'strength1' => 780
		}
	},
	{#State 624
		ACTIONS => {
			";" => 782,
			"," => 783
		}
	},
	{#State 625
		DEFAULT => -596
	},
	{#State 626
		ACTIONS => {
			";" => 784,
			"," => 785
		}
	},
	{#State 627
		DEFAULT => -223
	},
	{#State 628
		DEFAULT => -220
	},
	{#State 629
		ACTIONS => {
			"[" => 443,
			"=" => 787
		},
		DEFAULT => -257,
		GOTOS => {
			'opt_dimensions' => 786,
			'dimension' => 442,
			'dimensions' => 540
		}
	},
	{#State 630
		ACTIONS => {
			'IDENTIFIER' => 625
		},
		GOTOS => {
			'list_of_net_decl_assignments' => 788,
			'list_of_net_identifiers' => 789,
			'net_identifier' => 629,
			'net_identifier_dimensions' => 627,
			'net_decl_assignment' => 628
		}
	},
	{#State 631
		DEFAULT => -212
	},
	{#State 632
		DEFAULT => -211
	},
	{#State 633
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'mintypmax_expression' => 790,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 230,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 634
		DEFAULT => -206
	},
	{#State 635
		ACTIONS => {
			"." => 241,
			"E" => 242,
			"e" => 243
		},
		DEFAULT => -210,
		GOTOS => {
			'exp' => 239
		}
	},
	{#State 636
		ACTIONS => {
			'IDENTIFIER' => 625
		},
		GOTOS => {
			'list_of_net_decl_assignments' => 791,
			'net_identifier' => 792,
			'net_decl_assignment' => 628
		}
	},
	{#State 637
		ACTIONS => {
			"#" => 434
		},
		DEFAULT => -204,
		GOTOS => {
			'opt_delay3' => 793,
			'delay3' => 433
		}
	},
	{#State 638
		ACTIONS => {
			"[" => 190
		},
		GOTOS => {
			'range' => 794
		}
	},
	{#State 639
		ACTIONS => {
			"#" => 434
		},
		DEFAULT => -204,
		GOTOS => {
			'opt_delay3' => 795,
			'delay3' => 433
		}
	},
	{#State 640
		DEFAULT => -117
	},
	{#State 641
		DEFAULT => -260
	},
	{#State 642
		ACTIONS => {
			":" => 796
		}
	},
	{#State 643
		DEFAULT => -489
	},
	{#State 644
		DEFAULT => -180
	},
	{#State 645
		DEFAULT => -241
	},
	{#State 646
		DEFAULT => -237
	},
	{#State 647
		DEFAULT => -442
	},
	{#State 648
		ACTIONS => {
			"-" => 52,
			"posedge" => 802,
			"+" => 72,
			"~" => 54,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"negedge" => 803,
			"^" => 77,
			"!" => 58,
			"*" => 797,
			'IDENTIFIER' => 62,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87,
			"*)" => 800
		},
		GOTOS => {
			'event_expressions' => 801,
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 798,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'event_expression' => 799,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 649
		ACTIONS => {
			")" => 804
		}
	},
	{#State 650
		DEFAULT => -445
	},
	{#State 651
		DEFAULT => -440
	},
	{#State 652
		DEFAULT => -429
	},
	{#State 653
		ACTIONS => {
			"begin" => 472,
			"\@" => 453,
			";" => 805,
			"forever" => 473,
			"wait" => 475,
			'SYSTEM_IDENTIFIER' => 455,
			"if" => 476,
			"deassign" => 479,
			"disable" => 481,
			'IDENTIFIER' => 62,
			"{" => 483,
			"->" => 461,
			"while" => 485,
			"casex" => 486,
			"for" => 463,
			"force" => 490,
			"#" => 489,
			"release" => 467,
			"case" => 466,
			"assign" => 493,
			"fork" => 492,
			"casez" => 470,
			"repeat" => 494
		},
		GOTOS => {
			'conditional_statement' => 471,
			'seq_block' => 452,
			'procedural_timing_control' => 454,
			'nonblocking_assignment' => 474,
			'event_trigger' => 456,
			'hierarchical_task_identifier' => 477,
			'blocking_assignment' => 478,
			'delay_control' => 457,
			'event_control' => 480,
			'hierarchical_identifier_piece' => 60,
			'procedural_timing_control_statement' => 458,
			'hierarchical_identifier_pieces' => 78,
			'par_block' => 459,
			'lvalue' => 482,
			'case_statement' => 484,
			'hierarchical_identifier' => 460,
			'disable_statement' => 462,
			'wait_statement' => 487,
			'task_enable' => 464,
			'case_token' => 488,
			'procedural_continuous_assignment' => 465,
			'system_task_enable' => 491,
			'loop_statement' => 468,
			'system_task_identifier' => 469
		}
	},
	{#State 654
		DEFAULT => -456
	},
	{#State 655
		DEFAULT => -546
	},
	{#State 656
		ACTIONS => {
			"[" => 806
		},
		DEFAULT => -11,
		GOTOS => {
			'opt_bracket_expression' => 808,
			'bracket_expression' => 807
		}
	},
	{#State 657
		DEFAULT => -584
	},
	{#State 658
		ACTIONS => {
			'IDENTIFIER' => 62,
			"{" => 483
		},
		GOTOS => {
			'assignment' => 689,
			'lvalue' => 686,
			'hierarchical_identifier_piece' => 60,
			'variable_assignment' => 809,
			'hierarchical_identifier_pieces' => 78,
			'hierarchical_identifier' => 660
		}
	},
	{#State 659
		DEFAULT => -423
	},
	{#State 660
		ACTIONS => {
			"[" => 226
		},
		DEFAULT => -545,
		GOTOS => {
			'subscripts' => 655,
			'bracket_expression' => 228,
			'bracket_expressions' => 229
		}
	},
	{#State 661
		DEFAULT => -404
	},
	{#State 662
		ACTIONS => {
			";" => 810
		}
	},
	{#State 663
		ACTIONS => {
			'IDENTIFIER' => 811
		},
		GOTOS => {
			'block_identifier' => 812
		}
	},
	{#State 664
		DEFAULT => -413
	},
	{#State 665
		ACTIONS => {
			"end" => 813
		}
	},
	{#State 666
		ACTIONS => {
			"end" => -412,
			"join" => -412,
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statement' => 814,
			'attr' => 290
		}
	},
	{#State 667
		ACTIONS => {
			"end" => -411,
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statements' => 666,
			'opt_statements' => 815,
			'statement' => 664,
			'attr' => 290
		}
	},
	{#State 668
		DEFAULT => -470
	},
	{#State 669
		DEFAULT => -421
	},
	{#State 670
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 816,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 671
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 817,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 672
		ACTIONS => {
			";" => 818
		}
	},
	{#State 673
		DEFAULT => -415
	},
	{#State 674
		DEFAULT => -402
	},
	{#State 675
		ACTIONS => {
			";" => 819
		}
	},
	{#State 676
		DEFAULT => -593
	},
	{#State 677
		ACTIONS => {
			"\@" => 453,
			"#" => 489,
			"repeat" => 824
		},
		DEFAULT => -434,
		GOTOS => {
			'delay_control' => 820,
			'event_control' => 823,
			'delay_or_event_control' => 822,
			'opt_delay_or_event_control' => 821
		}
	},
	{#State 678
		ACTIONS => {
			"\@" => 453,
			"#" => 489,
			"repeat" => 824
		},
		DEFAULT => -434,
		GOTOS => {
			'delay_control' => 820,
			'event_control' => 823,
			'delay_or_event_control' => 822,
			'opt_delay_or_event_control' => 825
		}
	},
	{#State 679
		ACTIONS => {
			"}" => 826,
			"," => 827
		}
	},
	{#State 680
		DEFAULT => -543
	},
	{#State 681
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 828,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 682
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 829,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 683
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'mintypmax_expression' => 830,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 230,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 684
		DEFAULT => -432
	},
	{#State 685
		DEFAULT => -403
	},
	{#State 686
		ACTIONS => {
			"=" => 831
		}
	},
	{#State 687
		ACTIONS => {
			"join" => 832
		}
	},
	{#State 688
		ACTIONS => {
			"join" => -411,
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statements' => 666,
			'opt_statements' => 833,
			'statement' => 664,
			'attr' => 290
		}
	},
	{#State 689
		DEFAULT => -405
	},
	{#State 690
		DEFAULT => -401
	},
	{#State 691
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 834,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 692
		ACTIONS => {
			";" => 835,
			"," => 447
		}
	},
	{#State 693
		ACTIONS => {
			"(*" => 18,
			")" => 841
		},
		DEFAULT => -572,
		GOTOS => {
			'pip_task_port_item' => 836,
			'pic_task_port_item' => 837,
			'pic_task_port_items' => 840,
			'task_port_list' => 839,
			'attr' => 838
		}
	},
	{#State 694
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'task_item_declaration' => 845,
			'attr' => 842,
			'task_item_declarations' => 844,
			'block_item_declaration' => 843
		}
	},
	{#State 695
		DEFAULT => -227
	},
	{#State 696
		DEFAULT => -233
	},
	{#State 697
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 189,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'constant_expression' => 846,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 698
		DEFAULT => -231
	},
	{#State 699
		DEFAULT => -225
	},
	{#State 700
		DEFAULT => -109
	},
	{#State 701
		DEFAULT => -127
	},
	{#State 702
		DEFAULT => -128
	},
	{#State 703
		DEFAULT => -242
	},
	{#State 704
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		GOTOS => {
			'variable_port_identifier' => 847,
			'port_identifier' => 511
		}
	},
	{#State 705
		DEFAULT => -103
	},
	{#State 706
		DEFAULT => -203
	},
	{#State 707
		DEFAULT => -201
	},
	{#State 708
		DEFAULT => -202
	},
	{#State 709
		ACTIONS => {
			";" => 848,
			"," => 783
		}
	},
	{#State 710
		ACTIONS => {
			";" => 849,
			"," => 785
		}
	},
	{#State 711
		ACTIONS => {
			'IDENTIFIER' => 625
		},
		GOTOS => {
			'list_of_net_decl_assignments' => 850,
			'list_of_net_identifiers' => 851,
			'net_identifier' => 629,
			'net_identifier_dimensions' => 627,
			'net_decl_assignment' => 628
		}
	},
	{#State 712
		ACTIONS => {
			'IDENTIFIER' => 625
		},
		GOTOS => {
			'list_of_net_identifiers' => 852,
			'net_identifier' => 853,
			'net_identifier_dimensions' => 627
		}
	},
	{#State 713
		ACTIONS => {
			"#" => 434
		},
		DEFAULT => -204,
		GOTOS => {
			'opt_delay3' => 854,
			'delay3' => 433
		}
	},
	{#State 714
		ACTIONS => {
			"[" => 190
		},
		GOTOS => {
			'range' => 855
		}
	},
	{#State 715
		ACTIONS => {
			'IDENTIFIER' => 625
		},
		GOTOS => {
			'list_of_net_decl_assignments' => 856,
			'net_identifier' => 792,
			'net_decl_assignment' => 628
		}
	},
	{#State 716
		ACTIONS => {
			"#" => 434
		},
		DEFAULT => -204,
		GOTOS => {
			'opt_delay3' => 857,
			'delay3' => 433
		}
	},
	{#State 717
		ACTIONS => {
			"[" => 190
		},
		GOTOS => {
			'range' => 858
		}
	},
	{#State 718
		ACTIONS => {
			"#" => 434
		},
		DEFAULT => -204,
		GOTOS => {
			'opt_delay3' => 859,
			'delay3' => 433
		}
	},
	{#State 719
		DEFAULT => -219
	},
	{#State 720
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'mintypmax_expression' => 727,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 230,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'constant_mintypmax_expression' => 860,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 721
		DEFAULT => -111
	},
	{#State 722
		ACTIONS => {
			'IDENTIFIER' => 530,
			"PATHPULSE\$" => 534
		},
		GOTOS => {
			'pulse_control_specparam' => 529,
			'specparam_assignment' => 861,
			'specparam_identifier' => 531
		}
	},
	{#State 723
		ACTIONS => {
			"[" => 862
		},
		DEFAULT => -477
	},
	{#State 724
		ACTIONS => {
			"\$" => 863
		}
	},
	{#State 725
		ACTIONS => {
			"(" => 864
		}
	},
	{#State 726
		DEFAULT => -245
	},
	{#State 727
		DEFAULT => -488
	},
	{#State 728
		DEFAULT => -214
	},
	{#State 729
		DEFAULT => -217
	},
	{#State 730
		DEFAULT => -393
	},
	{#State 731
		DEFAULT => -395
	},
	{#State 732
		ACTIONS => {
			";" => 865,
			"," => 866
		}
	},
	{#State 733
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 189,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'constant_expression' => 867,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 734
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 189,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'constant_expression' => 868,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 735
		ACTIONS => {
			"-" => 52,
			"+" => 72,
			"~" => 54,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			'IDENTIFIER' => 62,
			"~^" => 83,
			"&" => 82,
			"{" => 81,
			'BASED_NUMBER' => 64,
			"(" => 68,
			"|" => 67,
			'UNSIGNED_NUMBER' => 85,
			"default" => 871,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'constant_expressions' => 872,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 189,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'genvar_case_items' => 869,
			'genvar_case_item' => 870,
			'constant_expression' => 873,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 736
		DEFAULT => -388
	},
	{#State 737
		ACTIONS => {
			"\@Regs" => 27,
			"\@Input" => 30,
			"\@Wires" => 33,
			"\@Waive" => 39,
			"\@Ports" => 40,
			"for" => 179,
			"case" => 182,
			"(*" => 18,
			"begin" => 183,
			";" => 875,
			"if" => 187,
			"\@Instance" => 35,
			"\@Vector" => 46,
			"\@Output" => 47
		},
		DEFAULT => -572,
		GOTOS => {
			'vp3_instance_directive' => 38,
			'vp3_vector_directive' => 22,
			'vp3_ports_directive' => 23,
			'module_or_generate_item' => 177,
			'vp3_regs_directive' => 24,
			'generate_case_statement' => 184,
			'vp3_module_item' => 28,
			'vp3_waive_directive' => 41,
			'vp3_force_directive' => 43,
			'attr' => 185,
			'generate_loop_statement' => 186,
			'generate_conditional_statement' => 180,
			'vp3_wires_directive' => 34,
			'generate_item' => 874,
			'generate_block' => 188,
			'generate_item_or_null' => 876
		}
	},
	{#State 738
		ACTIONS => {
			"]" => 877
		}
	},
	{#State 739
		DEFAULT => -523
	},
	{#State 740
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 878,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 741
		DEFAULT => -531
	},
	{#State 742
		DEFAULT => -534
	},
	{#State 743
		DEFAULT => -532
	},
	{#State 744
		DEFAULT => -533
	},
	{#State 745
		DEFAULT => -17
	},
	{#State 746
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 879,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 747
		DEFAULT => -483
	},
	{#State 748
		ACTIONS => {
			'UNSIGNED_NUMBER' => 880
		}
	},
	{#State 749
		ACTIONS => {
			"parameter" => 883
		},
		GOTOS => {
			'pdc_parameter_declarations' => 885,
			'pdp_parameter_declarations' => 881,
			'pdc_parameter_declaration' => 884,
			'pdp_parameter_declaration' => 882
		}
	},
	{#State 750
		ACTIONS => {
			"," => 886,
			")" => 887
		}
	},
	{#State 751
		DEFAULT => -118
	},
	{#State 752
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		DEFAULT => -120,
		GOTOS => {
			'port_identifier' => 750,
			'pic' => 889,
			'pip' => 888
		}
	},
	{#State 753
		DEFAULT => -20
	},
	{#State 754
		DEFAULT => -122
	},
	{#State 755
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		DEFAULT => -124,
		GOTOS => {
			'port_identifier' => 750,
			'pic' => 889,
			'pip' => 890
		}
	},
	{#State 756
		DEFAULT => -131
	},
	{#State 757
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		DEFAULT => -135,
		GOTOS => {
			'port_identifier' => 750,
			'pic' => 889,
			'pip' => 891
		}
	},
	{#State 758
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		DEFAULT => -136,
		GOTOS => {
			'vpip' => 893,
			'variable_port_identifier' => 759,
			'port_identifier' => 511,
			'vpic' => 892
		}
	},
	{#State 759
		ACTIONS => {
			"," => 894,
			")" => 895
		}
	},
	{#State 760
		DEFAULT => -24
	},
	{#State 761
		DEFAULT => -132
	},
	{#State 762
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			")" => -355,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		},
		DEFAULT => -10
	},
	{#State 763
		DEFAULT => -353
	},
	{#State 764
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		GOTOS => {
			'port_identifier' => 896
		}
	},
	{#State 765
		ACTIONS => {
			"," => 897
		}
	},
	{#State 766
		ACTIONS => {
			")" => 898
		}
	},
	{#State 767
		ACTIONS => {
			"," => 899
		},
		DEFAULT => -354
	},
	{#State 768
		DEFAULT => -359
	},
	{#State 769
		DEFAULT => -360
	},
	{#State 770
		DEFAULT => -349
	},
	{#State 771
		ACTIONS => {
			"." => 609
		},
		GOTOS => {
			'named_parameter_assignment' => 900
		}
	},
	{#State 772
		ACTIONS => {
			"(" => 901
		}
	},
	{#State 773
		DEFAULT => -341
	},
	{#State 774
		DEFAULT => -581
	},
	{#State 775
		ACTIONS => {
			"(" => 902,
			";" => 903
		}
	},
	{#State 776
		ACTIONS => {
			")" => 904
		}
	},
	{#State 777
		ACTIONS => {
			")" => 905
		}
	},
	{#State 778
		ACTIONS => {
			")" => 906
		}
	},
	{#State 779
		ACTIONS => {
			")" => 907
		}
	},
	{#State 780
		ACTIONS => {
			")" => 908
		}
	},
	{#State 781
		ACTIONS => {
			")" => 909
		}
	},
	{#State 782
		DEFAULT => -145
	},
	{#State 783
		ACTIONS => {
			'IDENTIFIER' => 625
		},
		GOTOS => {
			'net_identifier' => 792,
			'net_decl_assignment' => 910
		}
	},
	{#State 784
		DEFAULT => -144
	},
	{#State 785
		ACTIONS => {
			'IDENTIFIER' => 625
		},
		GOTOS => {
			'net_identifier' => 853,
			'net_identifier_dimensions' => 911
		}
	},
	{#State 786
		DEFAULT => -222
	},
	{#State 787
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 912,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 788
		ACTIONS => {
			";" => 913,
			"," => 783
		}
	},
	{#State 789
		ACTIONS => {
			";" => 914,
			"," => 785
		}
	},
	{#State 790
		ACTIONS => {
			"," => 915,
			")" => 916
		}
	},
	{#State 791
		ACTIONS => {
			";" => 917,
			"," => 783
		}
	},
	{#State 792
		ACTIONS => {
			"=" => 787
		}
	},
	{#State 793
		ACTIONS => {
			'IDENTIFIER' => 625
		},
		GOTOS => {
			'list_of_net_decl_assignments' => 918,
			'net_identifier' => 792,
			'net_decl_assignment' => 628
		}
	},
	{#State 794
		ACTIONS => {
			"#" => 434
		},
		DEFAULT => -204,
		GOTOS => {
			'opt_delay3' => 919,
			'delay3' => 433
		}
	},
	{#State 795
		ACTIONS => {
			'IDENTIFIER' => 625
		},
		GOTOS => {
			'list_of_net_decl_assignments' => 920,
			'list_of_net_identifiers' => 921,
			'net_identifier' => 629,
			'net_identifier_dimensions' => 627,
			'net_decl_assignment' => 628
		}
	},
	{#State 796
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'dimension_constant_expression' => 922,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 189,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'constant_expression' => 643,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 797
		ACTIONS => {
			")" => 923
		}
	},
	{#State 798
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		},
		DEFAULT => -451
	},
	{#State 799
		DEFAULT => -448
	},
	{#State 800
		DEFAULT => -446
	},
	{#State 801
		ACTIONS => {
			"or" => 924,
			"," => 925,
			")" => 926
		}
	},
	{#State 802
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 927,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 803
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 928,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 804
		DEFAULT => -444
	},
	{#State 805
		DEFAULT => -430
	},
	{#State 806
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 929,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 807
		DEFAULT => -12
	},
	{#State 808
		ACTIONS => {
			";" => 930
		}
	},
	{#State 809
		ACTIONS => {
			";" => 931
		}
	},
	{#State 810
		DEFAULT => -474
	},
	{#State 811
		DEFAULT => -579
	},
	{#State 812
		ACTIONS => {
			'opt_block_item_declarations' => 932
		}
	},
	{#State 813
		DEFAULT => -409
	},
	{#State 814
		DEFAULT => -414
	},
	{#State 815
		ACTIONS => {
			"end" => 933
		}
	},
	{#State 816
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			")" => 934,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		}
	},
	{#State 817
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			")" => 935,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		}
	},
	{#State 818
		DEFAULT => -475
	},
	{#State 819
		DEFAULT => -439
	},
	{#State 820
		DEFAULT => -436
	},
	{#State 821
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 936,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 822
		DEFAULT => -435
	},
	{#State 823
		DEFAULT => -437
	},
	{#State 824
		ACTIONS => {
			"(" => 937
		}
	},
	{#State 825
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 938,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 826
		DEFAULT => -547
	},
	{#State 827
		ACTIONS => {
			'IDENTIFIER' => 62,
			"{" => 483
		},
		GOTOS => {
			'lvalue' => 939,
			'hierarchical_identifier_piece' => 60,
			'hierarchical_identifier_pieces' => 78,
			'hierarchical_identifier' => 660
		}
	},
	{#State 828
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			")" => 940,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		}
	},
	{#State 829
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			")" => 941,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		}
	},
	{#State 830
		ACTIONS => {
			")" => 942
		}
	},
	{#State 831
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 943,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 832
		DEFAULT => -407
	},
	{#State 833
		ACTIONS => {
			"join" => 944
		}
	},
	{#State 834
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			")" => 945,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		}
	},
	{#State 835
		DEFAULT => -167
	},
	{#State 836
		DEFAULT => -295
	},
	{#State 837
		DEFAULT => -300
	},
	{#State 838
		ACTIONS => {
			"inout" => 951,
			"output" => 952,
			"input" => 948
		},
		GOTOS => {
			'pic_tf_inout_declaration' => 949,
			'pip_tf_output_declaration' => 947,
			'pip_tf_input_declaration' => 954,
			'pip_tf_inout_declaration' => 953,
			'pic_tf_output_declaration' => 946,
			'pic_tf_input_declaration' => 950
		}
	},
	{#State 839
		ACTIONS => {
			";" => 955
		}
	},
	{#State 840
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'pip_task_port_item' => 956,
			'pic_task_port_item' => 957,
			'attr' => 838
		}
	},
	{#State 841
		DEFAULT => -294
	},
	{#State 842
		ACTIONS => {
			"realtime" => 963,
			"reg" => 964,
			"real" => 969,
			"inout" => 965,
			"parameter" => 148,
			"output" => 967,
			"event" => 165,
			"input" => 961,
			"localparam" => 151,
			"time" => 971,
			"integer" => 962
		},
		GOTOS => {
			'pds_parameter_declaration' => 970,
			'local_parameter_declaration' => 960,
			'tf_input_declaration' => 966,
			'tf_inout_declaration' => 958,
			'event_declaration' => 959,
			'tf_output_declaration' => 968
		}
	},
	{#State 843
		DEFAULT => -290
	},
	{#State 844
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statement' => 652,
			'task_item_declaration' => 973,
			'attr' => 972,
			'statement_or_null' => 974,
			'block_item_declaration' => 843
		}
	},
	{#State 845
		DEFAULT => -288
	},
	{#State 846
		DEFAULT => -247
	},
	{#State 847
		DEFAULT => -244
	},
	{#State 848
		DEFAULT => -155
	},
	{#State 849
		DEFAULT => -153
	},
	{#State 850
		ACTIONS => {
			";" => 975,
			"," => 783
		}
	},
	{#State 851
		ACTIONS => {
			";" => 976,
			"," => 785
		}
	},
	{#State 852
		ACTIONS => {
			";" => 977,
			"," => 785
		}
	},
	{#State 853
		ACTIONS => {
			"[" => 443
		},
		DEFAULT => -257,
		GOTOS => {
			'opt_dimensions' => 786,
			'dimension' => 442,
			'dimensions' => 540
		}
	},
	{#State 854
		ACTIONS => {
			'IDENTIFIER' => 625
		},
		GOTOS => {
			'list_of_net_identifiers' => 978,
			'net_identifier' => 853,
			'net_identifier_dimensions' => 627
		}
	},
	{#State 855
		ACTIONS => {
			"#" => 434
		},
		DEFAULT => -204,
		GOTOS => {
			'opt_delay3' => 979,
			'delay3' => 433
		}
	},
	{#State 856
		ACTIONS => {
			";" => 980,
			"," => 783
		}
	},
	{#State 857
		ACTIONS => {
			'IDENTIFIER' => 625
		},
		GOTOS => {
			'list_of_net_decl_assignments' => 981,
			'net_identifier' => 792,
			'net_decl_assignment' => 628
		}
	},
	{#State 858
		ACTIONS => {
			"#" => 434
		},
		DEFAULT => -204,
		GOTOS => {
			'opt_delay3' => 982,
			'delay3' => 433
		}
	},
	{#State 859
		ACTIONS => {
			'IDENTIFIER' => 625
		},
		GOTOS => {
			'list_of_net_decl_assignments' => 983,
			'list_of_net_identifiers' => 984,
			'net_identifier' => 629,
			'net_identifier_dimensions' => 627,
			'net_decl_assignment' => 628
		}
	},
	{#State 860
		DEFAULT => -248
	},
	{#State 861
		DEFAULT => -239
	},
	{#State 862
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'base_expression' => 377,
			'multiple_concatenation' => 75,
			'msb_constant_expression' => 374,
			'range_expression' => 987,
			'expression' => 985,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'constant_expression' => 343,
			'concatenation' => 80,
			'real_number' => 63,
			'range_expression_colon' => 986,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 863
		ACTIONS => {
			'identifier' => 988
		},
		GOTOS => {
			'specify_output_terminal_descriptor' => 989
		}
	},
	{#State 864
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'mintypmax_expression' => 727,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 230,
			'limit_value' => 990,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'constant_mintypmax_expression' => 991,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'reject_limit_value' => 992,
			'unary_operator_expression' => 69
		}
	},
	{#State 865
		DEFAULT => -392
	},
	{#State 866
		ACTIONS => {
			'IDENTIFIER' => 62,
			"{" => 483
		},
		GOTOS => {
			'assignment' => 731,
			'lvalue' => 686,
			'hierarchical_identifier_piece' => 60,
			'hierarchical_identifier_pieces' => 78,
			'hierarchical_identifier' => 660,
			'net_assignment' => 993
		}
	},
	{#State 867
		ACTIONS => {
			";" => 994
		}
	},
	{#State 868
		DEFAULT => -387
	},
	{#State 869
		ACTIONS => {
			"-" => 52,
			"+" => 72,
			"~" => 54,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			'IDENTIFIER' => 62,
			"{" => 81,
			"~^" => 83,
			"&" => 82,
			'BASED_NUMBER' => 64,
			"(" => 68,
			"|" => 67,
			'UNSIGNED_NUMBER' => 85,
			"default" => 871,
			"endcase" => 996,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'constant_expressions' => 872,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 189,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'genvar_case_item' => 995,
			'constant_expression' => 873,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 870
		DEFAULT => -379
	},
	{#State 871
		ACTIONS => {
			":" => 997,
			"\@Regs" => 27,
			"\@Input" => 30,
			"\@Wires" => 33,
			"\@Waive" => 39,
			"\@Ports" => 40,
			"for" => 179,
			"case" => 182,
			"(*" => 18,
			"begin" => 183,
			";" => 875,
			"if" => 187,
			"\@Instance" => 35,
			"\@Vector" => 46,
			"\@Output" => 47
		},
		DEFAULT => -572,
		GOTOS => {
			'vp3_instance_directive' => 38,
			'vp3_vector_directive' => 22,
			'vp3_ports_directive' => 23,
			'module_or_generate_item' => 177,
			'vp3_regs_directive' => 24,
			'generate_case_statement' => 184,
			'vp3_module_item' => 28,
			'vp3_waive_directive' => 41,
			'vp3_force_directive' => 43,
			'attr' => 185,
			'generate_loop_statement' => 186,
			'generate_conditional_statement' => 180,
			'vp3_wires_directive' => 34,
			'generate_item' => 874,
			'generate_block' => 188,
			'generate_item_or_null' => 998
		}
	},
	{#State 872
		ACTIONS => {
			":" => 999,
			"," => 1000
		}
	},
	{#State 873
		DEFAULT => -381
	},
	{#State 874
		DEFAULT => -364
	},
	{#State 875
		DEFAULT => -365
	},
	{#State 876
		ACTIONS => {
			"else" => 1001
		},
		DEFAULT => -376,
		GOTOS => {
			'opt_generate_conditional_statement_else' => 1002
		}
	},
	{#State 877
		DEFAULT => -264
	},
	{#State 878
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"%" => 199,
			"==" => 200,
			">=" => 201,
			"*" => 203,
			">>" => 204,
			"||" => 205,
			"!==" => 206,
			"|" => 207,
			"<=" => 208,
			">" => 209,
			"**" => 210,
			"+" => 211,
			"<<<" => 212,
			"^" => 213,
			"!=" => 214,
			"&&" => 215,
			"?" => 216,
			"~^" => 217,
			"&" => 218,
			"===" => 219,
			"/" => 220,
			">>>" => 221,
			"<<" => 222,
			"^~" => 223
		},
		DEFAULT => -486
	},
	{#State 879
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		},
		DEFAULT => -527
	},
	{#State 880
		DEFAULT => -565
	},
	{#State 881
		DEFAULT => -54
	},
	{#State 882
		DEFAULT => -48
	},
	{#State 883
		ACTIONS => {
			"signed" => 276,
			"realtime" => 297,
			"time" => 299,
			"integer" => 295,
			"real" => 298
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 1004,
			'parameter_type' => 1003
		}
	},
	{#State 884
		DEFAULT => -50
	},
	{#State 885
		ACTIONS => {
			"parameter" => 883
		},
		GOTOS => {
			'pdc_parameter_declaration' => 1006,
			'pdp_parameter_declaration' => 1005
		}
	},
	{#State 886
		DEFAULT => -22
	},
	{#State 887
		DEFAULT => -19
	},
	{#State 888
		DEFAULT => -119
	},
	{#State 889
		DEFAULT => -21
	},
	{#State 890
		DEFAULT => -123
	},
	{#State 891
		DEFAULT => -133
	},
	{#State 892
		DEFAULT => -25
	},
	{#State 893
		DEFAULT => -134
	},
	{#State 894
		DEFAULT => -26
	},
	{#State 895
		DEFAULT => -23
	},
	{#State 896
		ACTIONS => {
			"(" => 1007
		}
	},
	{#State 897
		ACTIONS => {
			"-" => 52,
			"+" => 72,
			"~" => 54,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			'IDENTIFIER' => 62,
			"~^" => 83,
			"&" => 82,
			"{" => 81,
			'BASED_NUMBER' => 64,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		DEFAULT => -9,
		GOTOS => {
			'binary_operator_expression' => 70,
			'ordered_port_connection' => 1010,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 1008,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'opt_expression' => 768,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69,
			'ordered_port_connections' => 1009
		}
	},
	{#State 898
		DEFAULT => -350
	},
	{#State 899
		ACTIONS => {
			"." => 764
		},
		GOTOS => {
			'named_port_connection' => 1011
		}
	},
	{#State 900
		DEFAULT => -346
	},
	{#State 901
		ACTIONS => {
			"-" => 52,
			"+" => 72,
			"~" => 54,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			'IDENTIFIER' => 62,
			"~^" => 83,
			"&" => 82,
			"{" => 81,
			'BASED_NUMBER' => 64,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		DEFAULT => -524,
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'mintypmax_expression' => 1012,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 230,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'opt_mintypmax_expression' => 1013,
			'unary_operator_expression' => 69
		}
	},
	{#State 902
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'pic_function_ports' => 1017,
			'function_port_list' => 1014,
			'pic_function_port' => 1018,
			'pip_function_port' => 1015,
			'attr' => 1016
		}
	},
	{#State 903
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'function_item_declaration' => 1019,
			'attr' => 1021,
			'function_item_declarations' => 1020,
			'block_item_declaration' => 1022
		}
	},
	{#State 904
		DEFAULT => -191
	},
	{#State 905
		DEFAULT => -190
	},
	{#State 906
		DEFAULT => -188
	},
	{#State 907
		DEFAULT => -192
	},
	{#State 908
		DEFAULT => -187
	},
	{#State 909
		DEFAULT => -189
	},
	{#State 910
		DEFAULT => -221
	},
	{#State 911
		DEFAULT => -224
	},
	{#State 912
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		},
		DEFAULT => -246
	},
	{#State 913
		DEFAULT => -149
	},
	{#State 914
		DEFAULT => -147
	},
	{#State 915
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'mintypmax_expression' => 1023,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 230,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 916
		DEFAULT => -207
	},
	{#State 917
		DEFAULT => -146
	},
	{#State 918
		ACTIONS => {
			";" => 1024,
			"," => 783
		}
	},
	{#State 919
		ACTIONS => {
			'IDENTIFIER' => 625
		},
		GOTOS => {
			'list_of_net_decl_assignments' => 1025,
			'net_identifier' => 792,
			'net_decl_assignment' => 628
		}
	},
	{#State 920
		ACTIONS => {
			";" => 1026,
			"," => 783
		}
	},
	{#State 921
		ACTIONS => {
			";" => 1027,
			"," => 785
		}
	},
	{#State 922
		ACTIONS => {
			"]" => 1028
		}
	},
	{#State 923
		DEFAULT => -443
	},
	{#State 924
		ACTIONS => {
			"-" => 52,
			"posedge" => 802,
			"+" => 72,
			"~" => 54,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"negedge" => 803,
			"^" => 77,
			"!" => 58,
			'IDENTIFIER' => 62,
			"{" => 81,
			"~^" => 83,
			"&" => 82,
			'BASED_NUMBER' => 64,
			"(" => 68,
			"|" => 67,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 798,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'event_expression' => 1029,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 925
		ACTIONS => {
			"-" => 52,
			"posedge" => 802,
			"+" => 72,
			"~" => 54,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"negedge" => 803,
			"^" => 77,
			"!" => 58,
			'IDENTIFIER' => 62,
			"{" => 81,
			"~^" => 83,
			"&" => 82,
			'BASED_NUMBER' => 64,
			"(" => 68,
			"|" => 67,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 798,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'event_expression' => 1030,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 926
		DEFAULT => -441
	},
	{#State 927
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		},
		DEFAULT => -452
	},
	{#State 928
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		},
		DEFAULT => -453
	},
	{#State 929
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			"]" => 582,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		}
	},
	{#State 930
		DEFAULT => -447
	},
	{#State 931
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 1031,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 932
		DEFAULT => -406
	},
	{#State 933
		DEFAULT => -410
	},
	{#State 934
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statement' => 652,
			'attr' => 653,
			'statement_or_null' => 1032
		}
	},
	{#State 935
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statement' => 652,
			'attr' => 653,
			'statement_or_null' => 1033
		}
	},
	{#State 936
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		},
		DEFAULT => -400
	},
	{#State 937
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 1034,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 938
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		},
		DEFAULT => -399
	},
	{#State 939
		DEFAULT => -544
	},
	{#State 940
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statement' => 1035,
			'attr' => 290
		}
	},
	{#State 941
		ACTIONS => {
			"-" => 52,
			"+" => 72,
			"~" => 54,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			'IDENTIFIER' => 62,
			"~^" => 83,
			"&" => 82,
			"{" => 81,
			'BASED_NUMBER' => 64,
			"(" => 68,
			"|" => 67,
			'UNSIGNED_NUMBER' => 85,
			"default" => 1037,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'case_item' => 1036,
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expressions' => 1039,
			'expression' => 382,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69,
			'case_items' => 1038
		}
	},
	{#State 942
		DEFAULT => -433
	},
	{#State 943
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		},
		DEFAULT => -396
	},
	{#State 944
		DEFAULT => -408
	},
	{#State 945
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statement' => 1040,
			'attr' => 290
		}
	},
	{#State 946
		DEFAULT => -303
	},
	{#State 947
		DEFAULT => -298
	},
	{#State 948
		ACTIONS => {
			"realtime" => 1043,
			"reg" => 1044,
			"real" => 1046,
			"integer" => 1042,
			"time" => 1047
		},
		DEFAULT => -3,
		GOTOS => {
			'task_port_type' => 1045,
			'opt_reg' => 1041
		}
	},
	{#State 949
		DEFAULT => -304
	},
	{#State 950
		DEFAULT => -302
	},
	{#State 951
		ACTIONS => {
			"realtime" => 1043,
			"reg" => 1044,
			"real" => 1046,
			"integer" => 1042,
			"time" => 1047
		},
		DEFAULT => -3,
		GOTOS => {
			'task_port_type' => 1048,
			'opt_reg' => 1041
		}
	},
	{#State 952
		ACTIONS => {
			"realtime" => 1043,
			"reg" => 1044,
			"real" => 1046,
			"integer" => 1042,
			"time" => 1047
		},
		DEFAULT => -3,
		GOTOS => {
			'task_port_type' => 1049,
			'opt_reg' => 1041
		}
	},
	{#State 953
		DEFAULT => -299
	},
	{#State 954
		DEFAULT => -297
	},
	{#State 955
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'block_item_declarations' => 1052,
			'statement' => 652,
			'attr' => 1050,
			'statement_or_null' => 1053,
			'block_item_declaration' => 1051
		}
	},
	{#State 956
		DEFAULT => -296
	},
	{#State 957
		DEFAULT => -301
	},
	{#State 958
		ACTIONS => {
			";" => 1054
		}
	},
	{#State 959
		DEFAULT => -329
	},
	{#State 960
		DEFAULT => -330
	},
	{#State 961
		ACTIONS => {
			"realtime" => 1043,
			"reg" => 1044,
			"real" => 1046,
			"integer" => 1042,
			"time" => 1047
		},
		DEFAULT => -3,
		GOTOS => {
			'task_port_type' => 1055,
			'opt_reg' => 1041
		}
	},
	{#State 962
		ACTIONS => {
			'IDENTIFIER' => 284
		},
		GOTOS => {
			'block_variable_type' => 1057,
			'list_of_block_variable_identifiers' => 1058,
			'variable_identifier' => 1056
		}
	},
	{#State 963
		ACTIONS => {
			'IDENTIFIER' => 286
		},
		GOTOS => {
			'block_real_type' => 1059,
			'real_identifier' => 1060,
			'list_of_block_real_identifiers' => 1061
		}
	},
	{#State 964
		ACTIONS => {
			"signed" => 276
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 1062
		}
	},
	{#State 965
		ACTIONS => {
			"realtime" => 1043,
			"reg" => 1044,
			"real" => 1046,
			"integer" => 1042,
			"time" => 1047
		},
		DEFAULT => -3,
		GOTOS => {
			'task_port_type' => 1063,
			'opt_reg' => 1041
		}
	},
	{#State 966
		ACTIONS => {
			";" => 1064
		}
	},
	{#State 967
		ACTIONS => {
			"realtime" => 1043,
			"reg" => 1044,
			"real" => 1046,
			"integer" => 1042,
			"time" => 1047
		},
		DEFAULT => -3,
		GOTOS => {
			'task_port_type' => 1065,
			'opt_reg' => 1041
		}
	},
	{#State 968
		ACTIONS => {
			";" => 1066
		}
	},
	{#State 969
		ACTIONS => {
			'IDENTIFIER' => 286
		},
		GOTOS => {
			'block_real_type' => 1059,
			'real_identifier' => 1060,
			'list_of_block_real_identifiers' => 1067
		}
	},
	{#State 970
		DEFAULT => -331
	},
	{#State 971
		ACTIONS => {
			'IDENTIFIER' => 284
		},
		GOTOS => {
			'block_variable_type' => 1057,
			'list_of_block_variable_identifiers' => 1068,
			'variable_identifier' => 1056
		}
	},
	{#State 972
		ACTIONS => {
			"\@" => 453,
			'SYSTEM_IDENTIFIER' => 455,
			'IDENTIFIER' => 62,
			"->" => 461,
			"for" => 463,
			"release" => 467,
			"case" => 466,
			"input" => 961,
			"casez" => 470,
			"integer" => 962,
			"begin" => 472,
			"realtime" => 963,
			";" => 805,
			"reg" => 964,
			"forever" => 473,
			"wait" => 475,
			"if" => 476,
			"inout" => 965,
			"parameter" => 148,
			"deassign" => 479,
			"output" => 967,
			"localparam" => 151,
			"disable" => 481,
			"{" => 483,
			"while" => 485,
			"casex" => 486,
			"real" => 969,
			"#" => 489,
			"force" => 490,
			"event" => 165,
			"fork" => 492,
			"assign" => 493,
			"time" => 971,
			"repeat" => 494
		},
		GOTOS => {
			'conditional_statement' => 471,
			'seq_block' => 452,
			'procedural_timing_control' => 454,
			'nonblocking_assignment' => 474,
			'event_trigger' => 456,
			'hierarchical_task_identifier' => 477,
			'tf_input_declaration' => 966,
			'blocking_assignment' => 478,
			'delay_control' => 457,
			'event_control' => 480,
			'hierarchical_identifier_piece' => 60,
			'procedural_timing_control_statement' => 458,
			'hierarchical_identifier_pieces' => 78,
			'par_block' => 459,
			'tf_output_declaration' => 968,
			'lvalue' => 482,
			'tf_inout_declaration' => 958,
			'case_statement' => 484,
			'event_declaration' => 959,
			'hierarchical_identifier' => 460,
			'disable_statement' => 462,
			'wait_statement' => 487,
			'pds_parameter_declaration' => 970,
			'task_enable' => 464,
			'case_token' => 488,
			'local_parameter_declaration' => 960,
			'procedural_continuous_assignment' => 465,
			'system_task_enable' => 491,
			'loop_statement' => 468,
			'system_task_identifier' => 469
		}
	},
	{#State 973
		DEFAULT => -289
	},
	{#State 974
		ACTIONS => {
			"endtask" => 1069
		}
	},
	{#State 975
		DEFAULT => -161
	},
	{#State 976
		DEFAULT => -157
	},
	{#State 977
		DEFAULT => -154
	},
	{#State 978
		ACTIONS => {
			";" => 1070,
			"," => 785
		}
	},
	{#State 979
		ACTIONS => {
			'IDENTIFIER' => 625
		},
		GOTOS => {
			'list_of_net_identifiers' => 1071,
			'net_identifier' => 853,
			'net_identifier_dimensions' => 627
		}
	},
	{#State 980
		DEFAULT => -156
	},
	{#State 981
		ACTIONS => {
			";" => 1072,
			"," => 783
		}
	},
	{#State 982
		ACTIONS => {
			'IDENTIFIER' => 625
		},
		GOTOS => {
			'list_of_net_decl_assignments' => 1073,
			'net_identifier' => 792,
			'net_decl_assignment' => 628
		}
	},
	{#State 983
		ACTIONS => {
			";" => 1074,
			"," => 783
		}
	},
	{#State 984
		ACTIONS => {
			";" => 1075,
			"," => 785
		}
	},
	{#State 985
		ACTIONS => {
			":" => -487,
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			"]" => -529,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		},
		DEFAULT => -485
	},
	{#State 986
		DEFAULT => -530
	},
	{#State 987
		ACTIONS => {
			"]" => 1076
		}
	},
	{#State 988
		ACTIONS => {
			"[" => 1077
		},
		DEFAULT => -479
	},
	{#State 989
		ACTIONS => {
			"=" => 1078
		}
	},
	{#State 990
		DEFAULT => -255
	},
	{#State 991
		DEFAULT => -256
	},
	{#State 992
		ACTIONS => {
			"," => 1079,
			")" => 1080
		}
	},
	{#State 993
		DEFAULT => -394
	},
	{#State 994
		ACTIONS => {
			'IDENTIFIER' => 317
		},
		GOTOS => {
			'genvar_assignment' => 1081,
			'genvar_identifier' => 546
		}
	},
	{#State 995
		DEFAULT => -380
	},
	{#State 996
		DEFAULT => -378
	},
	{#State 997
		ACTIONS => {
			"\@Regs" => 27,
			"\@Input" => 30,
			"\@Wires" => 33,
			"\@Waive" => 39,
			"\@Ports" => 40,
			"for" => 179,
			"case" => 182,
			"(*" => 18,
			"begin" => 183,
			";" => 875,
			"if" => 187,
			"\@Instance" => 35,
			"\@Vector" => 46,
			"\@Output" => 47
		},
		DEFAULT => -572,
		GOTOS => {
			'vp3_instance_directive' => 38,
			'vp3_vector_directive' => 22,
			'vp3_ports_directive' => 23,
			'module_or_generate_item' => 177,
			'vp3_regs_directive' => 24,
			'generate_case_statement' => 184,
			'vp3_module_item' => 28,
			'vp3_waive_directive' => 41,
			'vp3_force_directive' => 43,
			'attr' => 185,
			'generate_loop_statement' => 186,
			'generate_conditional_statement' => 180,
			'vp3_wires_directive' => 34,
			'generate_item' => 874,
			'generate_block' => 188,
			'generate_item_or_null' => 1082
		}
	},
	{#State 998
		DEFAULT => -385
	},
	{#State 999
		ACTIONS => {
			"\@Regs" => 27,
			"\@Input" => 30,
			"\@Wires" => 33,
			"\@Waive" => 39,
			"\@Ports" => 40,
			"for" => 179,
			"case" => 182,
			"(*" => 18,
			"begin" => 183,
			";" => 875,
			"if" => 187,
			"\@Instance" => 35,
			"\@Vector" => 46,
			"\@Output" => 47
		},
		DEFAULT => -572,
		GOTOS => {
			'vp3_instance_directive' => 38,
			'vp3_vector_directive' => 22,
			'vp3_ports_directive' => 23,
			'module_or_generate_item' => 177,
			'vp3_regs_directive' => 24,
			'generate_case_statement' => 184,
			'vp3_module_item' => 28,
			'vp3_waive_directive' => 41,
			'vp3_force_directive' => 43,
			'attr' => 185,
			'generate_loop_statement' => 186,
			'generate_conditional_statement' => 180,
			'vp3_wires_directive' => 34,
			'generate_item' => 874,
			'generate_block' => 188,
			'generate_item_or_null' => 1083
		}
	},
	{#State 1000
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 189,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'constant_expression' => 1084,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 1001
		ACTIONS => {
			"\@Regs" => 27,
			"\@Input" => 30,
			"\@Wires" => 33,
			"\@Waive" => 39,
			"\@Ports" => 40,
			"for" => 179,
			"case" => 182,
			"(*" => 18,
			"begin" => 183,
			";" => 875,
			"if" => 187,
			"\@Instance" => 35,
			"\@Vector" => 46,
			"\@Output" => 47
		},
		DEFAULT => -572,
		GOTOS => {
			'vp3_instance_directive' => 38,
			'vp3_vector_directive' => 22,
			'vp3_ports_directive' => 23,
			'module_or_generate_item' => 177,
			'vp3_regs_directive' => 24,
			'generate_case_statement' => 184,
			'vp3_module_item' => 28,
			'vp3_waive_directive' => 41,
			'vp3_force_directive' => 43,
			'attr' => 185,
			'generate_loop_statement' => 186,
			'generate_conditional_statement' => 180,
			'vp3_wires_directive' => 34,
			'generate_item' => 874,
			'generate_block' => 188,
			'generate_item_or_null' => 1085
		}
	},
	{#State 1002
		DEFAULT => -375
	},
	{#State 1003
		ACTIONS => {
			'IDENTIFIER' => 501
		},
		GOTOS => {
			'parameter_identifier' => 503,
			'pap_param_assignment' => 1087,
			'pap_param_assignments' => 1086,
			'pac_param_assignment' => 499,
			'pac_param_assignments' => 1088,
			'param_assignment' => 1089
		}
	},
	{#State 1004
		ACTIONS => {
			"[" => 190
		},
		DEFAULT => -262,
		GOTOS => {
			'range' => 320,
			'opt_range' => 1090
		}
	},
	{#State 1005
		DEFAULT => -49
	},
	{#State 1006
		DEFAULT => -51
	},
	{#State 1007
		ACTIONS => {
			"-" => 52,
			"+" => 72,
			"~" => 54,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			'IDENTIFIER' => 62,
			"~^" => 83,
			"&" => 82,
			"{" => 81,
			'BASED_NUMBER' => 64,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		DEFAULT => -9,
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 1008,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'opt_expression' => 1091,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 1008
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		},
		DEFAULT => -10
	},
	{#State 1009
		ACTIONS => {
			"," => 1092
		},
		DEFAULT => -356
	},
	{#State 1010
		DEFAULT => -357
	},
	{#State 1011
		DEFAULT => -361
	},
	{#State 1012
		DEFAULT => -525
	},
	{#State 1013
		ACTIONS => {
			")" => 1093
		}
	},
	{#State 1014
		ACTIONS => {
			";" => 1094
		}
	},
	{#State 1015
		DEFAULT => -272
	},
	{#State 1016
		ACTIONS => {
			"input" => 948
		},
		GOTOS => {
			'pip_tf_input_declaration' => 1096,
			'pic_tf_input_declaration' => 1095
		}
	},
	{#State 1017
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'pic_function_port' => 1098,
			'pip_function_port' => 1097,
			'attr' => 1016
		}
	},
	{#State 1018
		DEFAULT => -275
	},
	{#State 1019
		DEFAULT => -268
	},
	{#State 1020
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statement' => 1099,
			'function_item_declaration' => 1100,
			'attr' => 1102,
			'function_statement' => 1101,
			'block_item_declaration' => 1022
		}
	},
	{#State 1021
		ACTIONS => {
			"realtime" => 963,
			"reg" => 964,
			"real" => 969,
			"parameter" => 148,
			"event" => 165,
			"input" => 961,
			"localparam" => 151,
			"time" => 971,
			"integer" => 962
		},
		GOTOS => {
			'pds_parameter_declaration' => 970,
			'local_parameter_declaration' => 960,
			'tf_input_declaration' => 1103,
			'event_declaration' => 959
		}
	},
	{#State 1022
		DEFAULT => -270
	},
	{#State 1023
		ACTIONS => {
			"," => 1104,
			")" => 1105
		}
	},
	{#State 1024
		DEFAULT => -150
	},
	{#State 1025
		ACTIONS => {
			";" => 1106,
			"," => 783
		}
	},
	{#State 1026
		DEFAULT => -151
	},
	{#State 1027
		DEFAULT => -148
	},
	{#State 1028
		DEFAULT => -261
	},
	{#State 1029
		DEFAULT => -449
	},
	{#State 1030
		DEFAULT => -450
	},
	{#State 1031
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			";" => 1107,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		}
	},
	{#State 1032
		DEFAULT => -457
	},
	{#State 1033
		ACTIONS => {
			"else" => 1109
		},
		DEFAULT => -459,
		GOTOS => {
			'opt_else' => 1108
		}
	},
	{#State 1034
		ACTIONS => {
			"-" => 197,
			"<" => 198,
			"+" => 211,
			"**" => 210,
			"%" => 199,
			"<<<" => 212,
			"==" => 200,
			">=" => 201,
			"^" => 213,
			"*" => 203,
			")" => 1110,
			">>" => 204,
			"!=" => 214,
			"?" => 216,
			"&&" => 215,
			"||" => 205,
			"!==" => 206,
			"===" => 219,
			"&" => 218,
			"~^" => 217,
			"/" => 220,
			">>>" => 221,
			"|" => 207,
			"<<" => 222,
			"^~" => 223,
			"<=" => 208,
			">" => 209
		}
	},
	{#State 1035
		DEFAULT => -472
	},
	{#State 1036
		DEFAULT => -465
	},
	{#State 1037
		ACTIONS => {
			":" => 1111,
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statement' => 652,
			'attr' => 653,
			'statement_or_null' => 1112
		}
	},
	{#State 1038
		ACTIONS => {
			"-" => 52,
			"+" => 72,
			"~" => 54,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			'IDENTIFIER' => 62,
			"{" => 81,
			"~^" => 83,
			"&" => 82,
			'BASED_NUMBER' => 64,
			"(" => 68,
			"|" => 67,
			'UNSIGNED_NUMBER' => 85,
			"default" => 1037,
			"endcase" => 1114,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'case_item' => 1113,
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expressions' => 1039,
			'expression' => 382,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 1039
		ACTIONS => {
			":" => 1115,
			"," => 387
		}
	},
	{#State 1040
		DEFAULT => -471
	},
	{#State 1041
		ACTIONS => {
			"signed" => 276
		},
		DEFAULT => -5,
		GOTOS => {
			'opt_signed' => 1116
		}
	},
	{#State 1042
		DEFAULT => -318
	},
	{#State 1043
		DEFAULT => -320
	},
	{#State 1044
		DEFAULT => -4
	},
	{#State 1045
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		GOTOS => {
			'pics' => 1118,
			'port_identifier' => 750,
			'pic' => 753,
			'pip' => 1117
		}
	},
	{#State 1046
		DEFAULT => -319
	},
	{#State 1047
		DEFAULT => -321
	},
	{#State 1048
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		GOTOS => {
			'pics' => 1120,
			'port_identifier' => 750,
			'pic' => 753,
			'pip' => 1119
		}
	},
	{#State 1049
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		GOTOS => {
			'pics' => 1122,
			'port_identifier' => 750,
			'pic' => 753,
			'pip' => 1121
		}
	},
	{#State 1050
		ACTIONS => {
			"begin" => 472,
			"realtime" => 963,
			"\@" => 453,
			";" => 805,
			"reg" => 964,
			"forever" => 473,
			"wait" => 475,
			'SYSTEM_IDENTIFIER' => 455,
			"if" => 476,
			"parameter" => 148,
			"deassign" => 479,
			"localparam" => 151,
			"disable" => 481,
			'IDENTIFIER' => 62,
			"{" => 483,
			"while" => 485,
			"->" => 461,
			"real" => 969,
			"casex" => 486,
			"for" => 463,
			"force" => 490,
			"#" => 489,
			"release" => 467,
			"case" => 466,
			"event" => 165,
			"assign" => 493,
			"fork" => 492,
			"time" => 971,
			"integer" => 962,
			"casez" => 470,
			"repeat" => 494
		},
		GOTOS => {
			'conditional_statement' => 471,
			'seq_block' => 452,
			'procedural_timing_control' => 454,
			'nonblocking_assignment' => 474,
			'event_trigger' => 456,
			'hierarchical_task_identifier' => 477,
			'blocking_assignment' => 478,
			'delay_control' => 457,
			'event_control' => 480,
			'hierarchical_identifier_piece' => 60,
			'procedural_timing_control_statement' => 458,
			'hierarchical_identifier_pieces' => 78,
			'par_block' => 459,
			'lvalue' => 482,
			'case_statement' => 484,
			'event_declaration' => 959,
			'hierarchical_identifier' => 460,
			'disable_statement' => 462,
			'wait_statement' => 487,
			'pds_parameter_declaration' => 970,
			'task_enable' => 464,
			'case_token' => 488,
			'local_parameter_declaration' => 960,
			'procedural_continuous_assignment' => 465,
			'system_task_enable' => 491,
			'loop_statement' => 468,
			'system_task_identifier' => 469
		}
	},
	{#State 1051
		DEFAULT => -322
	},
	{#State 1052
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statement' => 652,
			'attr' => 1050,
			'statement_or_null' => 1124,
			'block_item_declaration' => 1123
		}
	},
	{#State 1053
		ACTIONS => {
			"endtask" => 1125
		}
	},
	{#State 1054
		DEFAULT => -293
	},
	{#State 1055
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		GOTOS => {
			'list_of_port_identifiers' => 1126,
			'port_identifier' => 249
		}
	},
	{#State 1056
		ACTIONS => {
			"[" => 443
		},
		DEFAULT => -257,
		GOTOS => {
			'opt_dimensions' => 1127,
			'dimension' => 442,
			'dimensions' => 540
		}
	},
	{#State 1057
		DEFAULT => -332
	},
	{#State 1058
		ACTIONS => {
			";" => 1128,
			"," => 1129
		}
	},
	{#State 1059
		DEFAULT => -334
	},
	{#State 1060
		ACTIONS => {
			"[" => 443
		},
		DEFAULT => -257,
		GOTOS => {
			'opt_dimensions' => 1130,
			'dimension' => 442,
			'dimensions' => 540
		}
	},
	{#State 1061
		ACTIONS => {
			";" => 1131,
			"," => 1132
		}
	},
	{#State 1062
		ACTIONS => {
			"[" => 190
		},
		DEFAULT => -262,
		GOTOS => {
			'range' => 320,
			'opt_range' => 1133
		}
	},
	{#State 1063
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		GOTOS => {
			'list_of_port_identifiers' => 1134,
			'port_identifier' => 249
		}
	},
	{#State 1064
		DEFAULT => -291
	},
	{#State 1065
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		GOTOS => {
			'list_of_port_identifiers' => 1135,
			'port_identifier' => 249
		}
	},
	{#State 1066
		DEFAULT => -292
	},
	{#State 1067
		ACTIONS => {
			";" => 1136,
			"," => 1132
		}
	},
	{#State 1068
		ACTIONS => {
			";" => 1137,
			"," => 1129
		}
	},
	{#State 1069
		DEFAULT => -285
	},
	{#State 1070
		DEFAULT => -158
	},
	{#State 1071
		ACTIONS => {
			";" => 1138,
			"," => 785
		}
	},
	{#State 1072
		DEFAULT => -162
	},
	{#State 1073
		ACTIONS => {
			";" => 1139,
			"," => 783
		}
	},
	{#State 1074
		DEFAULT => -163
	},
	{#State 1075
		DEFAULT => -159
	},
	{#State 1076
		DEFAULT => -478
	},
	{#State 1077
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'base_expression' => 377,
			'multiple_concatenation' => 75,
			'msb_constant_expression' => 374,
			'range_expression' => 1140,
			'expression' => 985,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'constant_expression' => 343,
			'concatenation' => 80,
			'real_number' => 63,
			'range_expression_colon' => 986,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 1078
		ACTIONS => {
			"(" => 1141
		}
	},
	{#State 1079
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'mintypmax_expression' => 727,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 230,
			'limit_value' => 1142,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'constant_mintypmax_expression' => 991,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'error_limit_value' => 1143,
			'unary_operator_expression' => 69
		}
	},
	{#State 1080
		ACTIONS => {
			";" => 1144
		}
	},
	{#State 1081
		ACTIONS => {
			")" => 1145
		}
	},
	{#State 1082
		DEFAULT => -384
	},
	{#State 1083
		DEFAULT => -383
	},
	{#State 1084
		DEFAULT => -382
	},
	{#State 1085
		DEFAULT => -377
	},
	{#State 1086
		DEFAULT => -108
	},
	{#State 1087
		DEFAULT => -229
	},
	{#State 1088
		ACTIONS => {
			'IDENTIFIER' => 501
		},
		DEFAULT => -106,
		GOTOS => {
			'parameter_identifier' => 503,
			'pap_param_assignment' => 1146,
			'pac_param_assignment' => 695,
			'param_assignment' => 1089
		}
	},
	{#State 1089
		ACTIONS => {
			"," => 699,
			")" => 1147
		}
	},
	{#State 1090
		ACTIONS => {
			'IDENTIFIER' => 501
		},
		GOTOS => {
			'parameter_identifier' => 503,
			'pap_param_assignment' => 1087,
			'pap_param_assignments' => 1148,
			'pac_param_assignment' => 499,
			'pac_param_assignments' => 1149,
			'param_assignment' => 1089
		}
	},
	{#State 1091
		ACTIONS => {
			")" => 1150
		}
	},
	{#State 1092
		ACTIONS => {
			"-" => 52,
			"+" => 72,
			"~" => 54,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			'IDENTIFIER' => 62,
			"~^" => 83,
			"&" => 82,
			"{" => 81,
			'BASED_NUMBER' => 64,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		DEFAULT => -9,
		GOTOS => {
			'binary_operator_expression' => 70,
			'ordered_port_connection' => 1151,
			'number' => 71,
			'system_function_call' => 53,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 1008,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'opt_expression' => 768,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 1093
		DEFAULT => -347
	},
	{#State 1094
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'block_item_declarations' => 1154,
			'statement' => 1099,
			'attr' => 1153,
			'function_statement' => 1152,
			'block_item_declaration' => 1051
		}
	},
	{#State 1095
		DEFAULT => -277
	},
	{#State 1096
		DEFAULT => -274
	},
	{#State 1097
		DEFAULT => -273
	},
	{#State 1098
		DEFAULT => -276
	},
	{#State 1099
		DEFAULT => -431
	},
	{#State 1100
		DEFAULT => -269
	},
	{#State 1101
		ACTIONS => {
			"endfunction" => 1155
		}
	},
	{#State 1102
		ACTIONS => {
			"begin" => 472,
			"realtime" => 963,
			"\@" => 453,
			"reg" => 964,
			"forever" => 473,
			"wait" => 475,
			'SYSTEM_IDENTIFIER' => 455,
			"if" => 476,
			"parameter" => 148,
			"deassign" => 479,
			"localparam" => 151,
			"disable" => 481,
			'IDENTIFIER' => 62,
			"{" => 483,
			"while" => 485,
			"->" => 461,
			"real" => 969,
			"casex" => 486,
			"for" => 463,
			"force" => 490,
			"#" => 489,
			"release" => 467,
			"case" => 466,
			"event" => 165,
			"assign" => 493,
			"fork" => 492,
			"input" => 961,
			"time" => 971,
			"casez" => 470,
			"integer" => 962,
			"repeat" => 494
		},
		GOTOS => {
			'conditional_statement' => 471,
			'seq_block' => 452,
			'procedural_timing_control' => 454,
			'nonblocking_assignment' => 474,
			'event_trigger' => 456,
			'hierarchical_task_identifier' => 477,
			'tf_input_declaration' => 1103,
			'blocking_assignment' => 478,
			'delay_control' => 457,
			'event_control' => 480,
			'hierarchical_identifier_piece' => 60,
			'procedural_timing_control_statement' => 458,
			'hierarchical_identifier_pieces' => 78,
			'par_block' => 459,
			'lvalue' => 482,
			'case_statement' => 484,
			'event_declaration' => 959,
			'hierarchical_identifier' => 460,
			'disable_statement' => 462,
			'wait_statement' => 487,
			'pds_parameter_declaration' => 970,
			'task_enable' => 464,
			'case_token' => 488,
			'local_parameter_declaration' => 960,
			'procedural_continuous_assignment' => 465,
			'system_task_enable' => 491,
			'loop_statement' => 468,
			'system_task_identifier' => 469
		}
	},
	{#State 1103
		ACTIONS => {
			";" => 1156
		}
	},
	{#State 1104
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'mintypmax_expression' => 1157,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 230,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'unary_operator_expression' => 69
		}
	},
	{#State 1105
		DEFAULT => -208
	},
	{#State 1106
		DEFAULT => -152
	},
	{#State 1107
		ACTIONS => {
			'IDENTIFIER' => 62,
			"{" => 483
		},
		GOTOS => {
			'assignment' => 689,
			'lvalue' => 686,
			'hierarchical_identifier_piece' => 60,
			'variable_assignment' => 1158,
			'hierarchical_identifier_pieces' => 78,
			'hierarchical_identifier' => 660
		}
	},
	{#State 1108
		DEFAULT => -458
	},
	{#State 1109
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statement' => 652,
			'attr' => 653,
			'statement_or_null' => 1159
		}
	},
	{#State 1110
		ACTIONS => {
			"\@" => 453
		},
		GOTOS => {
			'event_control' => 1160
		}
	},
	{#State 1111
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statement' => 652,
			'attr' => 653,
			'statement_or_null' => 1161
		}
	},
	{#State 1112
		DEFAULT => -469
	},
	{#State 1113
		DEFAULT => -466
	},
	{#State 1114
		DEFAULT => -464
	},
	{#State 1115
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statement' => 652,
			'attr' => 653,
			'statement_or_null' => 1162
		}
	},
	{#State 1116
		ACTIONS => {
			"[" => 190
		},
		DEFAULT => -262,
		GOTOS => {
			'range' => 320,
			'opt_range' => 1163
		}
	},
	{#State 1117
		DEFAULT => -305
	},
	{#State 1118
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		DEFAULT => -307,
		GOTOS => {
			'port_identifier' => 750,
			'pic' => 889,
			'pip' => 1164
		}
	},
	{#State 1119
		DEFAULT => -313
	},
	{#State 1120
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		DEFAULT => -315,
		GOTOS => {
			'port_identifier' => 750,
			'pic' => 889,
			'pip' => 1165
		}
	},
	{#State 1121
		DEFAULT => -309
	},
	{#State 1122
		ACTIONS => {
			'IDENTIFIER' => 250
		},
		DEFAULT => -311,
		GOTOS => {
			'port_identifier' => 750,
			'pic' => 889,
			'pip' => 1166
		}
	},
	{#State 1123
		DEFAULT => -323
	},
	{#State 1124
		ACTIONS => {
			"endtask" => 1167
		}
	},
	{#State 1125
		DEFAULT => -286
	},
	{#State 1126
		ACTIONS => {
			"," => 395
		},
		DEFAULT => -308
	},
	{#State 1127
		DEFAULT => -336
	},
	{#State 1128
		DEFAULT => -325
	},
	{#State 1129
		ACTIONS => {
			'IDENTIFIER' => 284
		},
		GOTOS => {
			'block_variable_type' => 1168,
			'variable_identifier' => 1056
		}
	},
	{#State 1130
		DEFAULT => -337
	},
	{#State 1131
		DEFAULT => -328
	},
	{#State 1132
		ACTIONS => {
			'IDENTIFIER' => 286
		},
		GOTOS => {
			'block_real_type' => 1169,
			'real_identifier' => 1060
		}
	},
	{#State 1133
		ACTIONS => {
			'IDENTIFIER' => 284
		},
		GOTOS => {
			'block_variable_type' => 1057,
			'list_of_block_variable_identifiers' => 1170,
			'variable_identifier' => 1056
		}
	},
	{#State 1134
		ACTIONS => {
			"," => 395
		},
		DEFAULT => -316
	},
	{#State 1135
		ACTIONS => {
			"," => 395
		},
		DEFAULT => -312
	},
	{#State 1136
		DEFAULT => -327
	},
	{#State 1137
		DEFAULT => -326
	},
	{#State 1138
		DEFAULT => -160
	},
	{#State 1139
		DEFAULT => -164
	},
	{#State 1140
		ACTIONS => {
			"]" => 1171
		}
	},
	{#State 1141
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'mintypmax_expression' => 727,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 230,
			'limit_value' => 990,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'constant_mintypmax_expression' => 991,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'reject_limit_value' => 1172,
			'unary_operator_expression' => 69
		}
	},
	{#State 1142
		DEFAULT => -254
	},
	{#State 1143
		ACTIONS => {
			")" => 1173
		}
	},
	{#State 1144
		DEFAULT => -250
	},
	{#State 1145
		ACTIONS => {
			"begin" => 1174
		}
	},
	{#State 1146
		DEFAULT => -230
	},
	{#State 1147
		DEFAULT => -228
	},
	{#State 1148
		DEFAULT => -107
	},
	{#State 1149
		ACTIONS => {
			'IDENTIFIER' => 501
		},
		DEFAULT => -105,
		GOTOS => {
			'parameter_identifier' => 503,
			'pap_param_assignment' => 1146,
			'pac_param_assignment' => 695,
			'param_assignment' => 1089
		}
	},
	{#State 1150
		DEFAULT => -362
	},
	{#State 1151
		DEFAULT => -358
	},
	{#State 1152
		ACTIONS => {
			"endfunction" => 1175
		}
	},
	{#State 1153
		ACTIONS => {
			"begin" => 472,
			"realtime" => 963,
			"\@" => 453,
			"reg" => 964,
			"forever" => 473,
			"wait" => 475,
			'SYSTEM_IDENTIFIER' => 455,
			"if" => 476,
			"parameter" => 148,
			"deassign" => 479,
			"localparam" => 151,
			"disable" => 481,
			'IDENTIFIER' => 62,
			"{" => 483,
			"while" => 485,
			"->" => 461,
			"real" => 969,
			"casex" => 486,
			"for" => 463,
			"force" => 490,
			"#" => 489,
			"release" => 467,
			"case" => 466,
			"event" => 165,
			"assign" => 493,
			"fork" => 492,
			"time" => 971,
			"integer" => 962,
			"casez" => 470,
			"repeat" => 494
		},
		GOTOS => {
			'conditional_statement' => 471,
			'seq_block' => 452,
			'procedural_timing_control' => 454,
			'nonblocking_assignment' => 474,
			'event_trigger' => 456,
			'hierarchical_task_identifier' => 477,
			'blocking_assignment' => 478,
			'delay_control' => 457,
			'event_control' => 480,
			'hierarchical_identifier_piece' => 60,
			'procedural_timing_control_statement' => 458,
			'hierarchical_identifier_pieces' => 78,
			'par_block' => 459,
			'lvalue' => 482,
			'case_statement' => 484,
			'event_declaration' => 959,
			'hierarchical_identifier' => 460,
			'disable_statement' => 462,
			'wait_statement' => 487,
			'pds_parameter_declaration' => 970,
			'task_enable' => 464,
			'case_token' => 488,
			'local_parameter_declaration' => 960,
			'procedural_continuous_assignment' => 465,
			'system_task_enable' => 491,
			'loop_statement' => 468,
			'system_task_identifier' => 469
		}
	},
	{#State 1154
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statement' => 1099,
			'attr' => 1153,
			'function_statement' => 1176,
			'block_item_declaration' => 1123
		}
	},
	{#State 1155
		DEFAULT => -265
	},
	{#State 1156
		DEFAULT => -271
	},
	{#State 1157
		ACTIONS => {
			")" => 1177
		}
	},
	{#State 1158
		ACTIONS => {
			")" => 1178
		}
	},
	{#State 1159
		DEFAULT => -460
	},
	{#State 1160
		DEFAULT => -438
	},
	{#State 1161
		DEFAULT => -468
	},
	{#State 1162
		DEFAULT => -467
	},
	{#State 1163
		DEFAULT => -317
	},
	{#State 1164
		DEFAULT => -306
	},
	{#State 1165
		DEFAULT => -314
	},
	{#State 1166
		DEFAULT => -310
	},
	{#State 1167
		DEFAULT => -287
	},
	{#State 1168
		DEFAULT => -333
	},
	{#State 1169
		DEFAULT => -335
	},
	{#State 1170
		ACTIONS => {
			";" => 1179,
			"," => 1129
		}
	},
	{#State 1171
		DEFAULT => -480
	},
	{#State 1172
		ACTIONS => {
			"," => 1180,
			")" => 1181
		}
	},
	{#State 1173
		ACTIONS => {
			";" => 1182
		}
	},
	{#State 1174
		ACTIONS => {
			":" => 1183
		}
	},
	{#State 1175
		DEFAULT => -266
	},
	{#State 1176
		ACTIONS => {
			"endfunction" => 1184
		}
	},
	{#State 1177
		DEFAULT => -209
	},
	{#State 1178
		ACTIONS => {
			"(*" => 18
		},
		DEFAULT => -572,
		GOTOS => {
			'statement' => 1185,
			'attr' => 290
		}
	},
	{#State 1179
		DEFAULT => -324
	},
	{#State 1180
		ACTIONS => {
			"-" => 52,
			'IDENTIFIER' => 62,
			"+" => 72,
			"~" => 54,
			"{" => 81,
			"&" => 82,
			"~^" => 83,
			'BASED_NUMBER' => 64,
			"~|" => 74,
			'STRING' => 76,
			'SYSTEM_IDENTIFIER' => 57,
			"^" => 77,
			"!" => 58,
			"|" => 67,
			"(" => 68,
			'UNSIGNED_NUMBER' => 85,
			"^~" => 86,
			"~&" => 87
		},
		GOTOS => {
			'binary_operator_expression' => 70,
			'number' => 71,
			'system_function_call' => 53,
			'mintypmax_expression' => 727,
			'primary' => 73,
			'conditional_expression' => 55,
			'string' => 56,
			'multiple_concatenation' => 75,
			'expression' => 230,
			'limit_value' => 1142,
			'hierarchical_identifier_piece' => 60,
			'unary_operator' => 61,
			'hierarchical_identifier_pieces' => 78,
			'constant_mintypmax_expression' => 991,
			'system_function_identifier' => 79,
			'concatenation' => 80,
			'real_number' => 63,
			'hierarchical_identifier' => 65,
			'hierarchical_function_identifier' => 84,
			'function_call' => 66,
			'error_limit_value' => 1186,
			'unary_operator_expression' => 69
		}
	},
	{#State 1181
		ACTIONS => {
			";" => 1187
		}
	},
	{#State 1182
		DEFAULT => -251
	},
	{#State 1183
		ACTIONS => {
			'IDENTIFIER' => 548
		},
		GOTOS => {
			'generate_block_identifier' => 1188
		}
	},
	{#State 1184
		DEFAULT => -267
	},
	{#State 1185
		DEFAULT => -473
	},
	{#State 1186
		ACTIONS => {
			")" => 1189
		}
	},
	{#State 1187
		DEFAULT => -252
	},
	{#State 1188
		ACTIONS => {
			"\@Regs" => 27,
			"\@Input" => 30,
			"\@Wires" => 33,
			"\@Waive" => 39,
			"\@Ports" => 40,
			"for" => 179,
			"case" => 182,
			"(*" => 18,
			"begin" => 183,
			"if" => 187,
			"end" => -366,
			"\@Instance" => 35,
			"\@Vector" => 46,
			"\@Output" => 47
		},
		DEFAULT => -572,
		GOTOS => {
			'vp3_vector_directive' => 22,
			'opt_generate_items' => 1190,
			'vp3_ports_directive' => 23,
			'module_or_generate_item' => 177,
			'vp3_regs_directive' => 24,
			'generate_case_statement' => 184,
			'vp3_module_item' => 28,
			'attr' => 185,
			'generate_loop_statement' => 186,
			'vp3_wires_directive' => 34,
			'generate_items' => 178,
			'generate_block' => 188,
			'vp3_instance_directive' => 38,
			'vp3_waive_directive' => 41,
			'vp3_force_directive' => 43,
			'generate_conditional_statement' => 180,
			'generate_item' => 181
		}
	},
	{#State 1189
		ACTIONS => {
			";" => 1191
		}
	},
	{#State 1190
		ACTIONS => {
			"end" => 1192
		}
	},
	{#State 1191
		DEFAULT => -253
	},
	{#State 1192
		DEFAULT => -386
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'opt_arguments', 0,
sub
#line 103 "verilog.yapp"
{ null }
	],
	[#Rule 2
		 'opt_arguments', 3,
sub
#line 104 "verilog.yapp"
{ $_[2]->prepend_text ($_[1])->append_text ($_[3]) }
	],
	[#Rule 3
		 'opt_reg', 0,
sub
#line 107 "verilog.yapp"
{ null }
	],
	[#Rule 4
		 'opt_reg', 1, undef
	],
	[#Rule 5
		 'opt_signed', 0,
sub
#line 111 "verilog.yapp"
{ null }
	],
	[#Rule 6
		 'opt_signed', 1, undef
	],
	[#Rule 7
		 'opt_automatic', 0,
sub
#line 115 "verilog.yapp"
{ null }
	],
	[#Rule 8
		 'opt_automatic', 1, undef
	],
	[#Rule 9
		 'opt_expression', 0,
sub
#line 119 "verilog.yapp"
{ null }
	],
	[#Rule 10
		 'opt_expression', 1, undef
	],
	[#Rule 11
		 'opt_bracket_expression', 0,
sub
#line 123 "verilog.yapp"
{ null }
	],
	[#Rule 12
		 'opt_bracket_expression', 1, undef
	],
	[#Rule 13
		 'bracket_expression', 3,
sub
#line 127 "verilog.yapp"
{ $_[2]->prepend_text ($_[1])->append_text ($_[3]); f ("subscripts", $_[2]) }
	],
	[#Rule 14
		 'bracket_expressions', 1,
sub
#line 130 "verilog.yapp"
{ $_[1] }
	],
	[#Rule 15
		 'bracket_expressions', 2,
sub
#line 131 "verilog.yapp"
{ $_[1]->append_children ($_[2]) }
	],
	[#Rule 16
		 'subscripts', 1,
sub
#line 134 "verilog.yapp"
{ $_[1] }
	],
	[#Rule 17
		 'subscripts', 4,
sub
#line 135 "verilog.yapp"
{ $_[3]->prepend_text ($_[2])->append_text ($_[4]); $_[1]->append_children ($_[3]) }
	],
	[#Rule 18
		 'subscripts', 3,
sub
#line 136 "verilog.yapp"
{ $_[2]->prepend_text ($_[1])->append_text ($_[3]); f ("subscripts", $_[2]) }
	],
	[#Rule 19
		 'pip', 2,
sub
#line 139 "verilog.yapp"
{ $_[1]->append_text ($_[2]) }
	],
	[#Rule 20
		 'pics', 1,
sub
#line 142 "verilog.yapp"
{ f ("list_of_port_identifiers", $_[1]) }
	],
	[#Rule 21
		 'pics', 2,
sub
#line 143 "verilog.yapp"
{ $_[1]->append_children ($_[2]) }
	],
	[#Rule 22
		 'pic', 2,
sub
#line 146 "verilog.yapp"
{ $_[1]->append_text ($_[2]) }
	],
	[#Rule 23
		 'vpip', 2,
sub
#line 149 "verilog.yapp"
{ $_[1]->append_text ($_[2]) }
	],
	[#Rule 24
		 'vpics', 1,
sub
#line 152 "verilog.yapp"
{ f ("list_of_variable_port_identifiers", $_[1]) }
	],
	[#Rule 25
		 'vpics', 2,
sub
#line 153 "verilog.yapp"
{ $_[1]->append_children ($_[2]) }
	],
	[#Rule 26
		 'vpic', 2,
sub
#line 156 "verilog.yapp"
{ $_[1]->append_text ($_[2]) }
	],
	[#Rule 27
		 'source_text', 0,
sub
#line 169 "verilog.yapp"
{ f ("source_text") }
	],
	[#Rule 28
		 'source_text', 1,
sub
#line 170 "verilog.yapp"
{ f ("source_text", $_[1]) }
	],
	[#Rule 29
		 'source_text', 1, undef
	],
	[#Rule 30
		 'descriptions', 1,
sub
#line 174 "verilog.yapp"
{ f ("source_text", $_[1]) }
	],
	[#Rule 31
		 'descriptions', 2,
sub
#line 175 "verilog.yapp"
{ $_[1]->append_children ($_[2]) }
	],
	[#Rule 32
		 'description', 1, undef
	],
	[#Rule 33
		 'description', 1, undef
	],
	[#Rule 34
		 '@1-3', 0,
sub
#line 187 "verilog.yapp"
{
                       $_[2]->prepend_text ($_[1]);
                       my $obj = f ("module_declaration", @_[2,3]);
                       $_[0]->scope ($obj);
                       $obj;
                   }
	],
	[#Rule 35
		 'module_preamble', 5,
sub
#line 194 "verilog.yapp"
{
                       $_[4]->append_children ($_[5]);
                       $_[4];
                   }
	],
	[#Rule 36
		 'noport_module_header', 2,
sub
#line 201 "verilog.yapp"
{
                            $_[1]->append_text ($_[2]);
                            $_[1]->append_children (null); # port list
                        }
	],
	[#Rule 37
		 'traditional_module_header', 5,
sub
#line 211 "verilog.yapp"
{
                                 $_[3]->prepend_text ($_[2]);
                                 $_[3]->append_text ($_[4]);
                                 $_[3]->append_text ($_[5]);
                                 $_[1]->append_children ($_[3]);
                             }
	],
	[#Rule 38
		 'v2k_module_header', 4,
sub
#line 221 "verilog.yapp"
{
                         $_[3]->prepend_text ($_[2]);
                         $_[3]->append_text ($_[4]);
                         $_[1]->append_children ($_[3]);
                     }
	],
	[#Rule 39
		 'module_declaration', 3,
sub
#line 236 "verilog.yapp"
{
                          $_[0]->scope (undef);
                          $_[1]->append_children (@_[2,3]);
                      }
	],
	[#Rule 40
		 'module_declaration', 3,
sub
#line 243 "verilog.yapp"
{
                          $_[0]->scope (undef);
                          $_[1]->append_children (@_[2,3]);
                      }
	],
	[#Rule 41
		 'module_declaration', 3,
sub
#line 250 "verilog.yapp"
{
                          $_[0]->scope (undef);
                          $_[1]->append_children (@_[2,3]);
                      }
	],
	[#Rule 42
		 '@2-1', 0,
sub
#line 255 "verilog.yapp"
{
                          my $obj = f ("vp3_module_declaration", $_[1]);
                          $_[0]->scope ($obj);
                          $obj;
                      }
	],
	[#Rule 43
		 'module_declaration', 4,
sub
#line 262 "verilog.yapp"
{
                          $_[0]->scope (undef);
                          $_[2]->append_children (@_[3,4]);
                      }
	],
	[#Rule 44
		 '@3-1', 0,
sub
#line 270 "verilog.yapp"
{
                          my $obj = f ("vp3_module_declaration", $_[1]);
                          $_[0]->scope ($obj);
                          $obj;
                      }
	],
	[#Rule 45
		 'module_none_declaration', 4,
sub
#line 277 "verilog.yapp"
{
                          $_[0]->scope (undef);
                          $_[2]->append_children ($_[4], null);
                      }
	],
	[#Rule 46
		 'module_keyword', 1, undef
	],
	[#Rule 47
		 'module_keyword', 1, undef
	],
	[#Rule 48
		 'pdp_parameter_declarations', 1,
sub
#line 289 "verilog.yapp"
{ f ("list_of_parameter_declarations", $_[1]) }
	],
	[#Rule 49
		 'pdp_parameter_declarations', 2,
sub
#line 290 "verilog.yapp"
{ $_[1]->append_children ($_[2]) }
	],
	[#Rule 50
		 'pdc_parameter_declarations', 1,
sub
#line 293 "verilog.yapp"
{ f ("list_of_parameter_declarations", $_[1]) }
	],
	[#Rule 51
		 'pdc_parameter_declarations', 2,
sub
#line 294 "verilog.yapp"
{ $_[1]->append_children ($_[2]) }
	],
	[#Rule 52
		 'opt_module_parameter_port_list', 0,
sub
#line 297 "verilog.yapp"
{ null }
	],
	[#Rule 53
		 'opt_module_parameter_port_list', 1, undef
	],
	[#Rule 54
		 'module_parameter_port_list', 3,
sub
#line 301 "verilog.yapp"
{ $_[3]->prepend_text ($_[2])->prepend_text ($_[1]); $_[3] }
	],
	[#Rule 55
		 'list_of_port_declarations', 1,
sub
#line 304 "verilog.yapp"
{ f ("list_of_port_declarations", "")->append_text ($_[1]) }
	],
	[#Rule 56
		 'list_of_port_declarations', 1,
sub
#line 305 "verilog.yapp"
{ f ("list_of_port_declarations", $_[1])                   }
	],
	[#Rule 57
		 'list_of_port_declarations', 2,
sub
#line 306 "verilog.yapp"
{ $_[1]->append_children ($_[2])                           }
	],
	[#Rule 58
		 'pip_port_declaration', 2,
sub
#line 309 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 59
		 'pip_port_declaration', 2,
sub
#line 310 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 60
		 'pip_port_declaration', 2,
sub
#line 311 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 61
		 'pic_port_declarations', 1,
sub
#line 314 "verilog.yapp"
{ f ("list_of_port_declarations", $_[1]) }
	],
	[#Rule 62
		 'pic_port_declarations', 2,
sub
#line 315 "verilog.yapp"
{ $_[1]->append_children ($_[2]) }
	],
	[#Rule 63
		 'pic_port_declaration', 2,
sub
#line 318 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 64
		 'pic_port_declaration', 2,
sub
#line 319 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 65
		 'pic_port_declaration', 2,
sub
#line 320 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 66
		 'port_declaration', 2,
sub
#line 323 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 67
		 'port_declaration', 2,
sub
#line 324 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 68
		 'port_declaration', 2,
sub
#line 325 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 69
		 'opt_module_items', 0,
sub
#line 330 "verilog.yapp"
{ null }
	],
	[#Rule 70
		 'opt_module_items', 1, undef
	],
	[#Rule 71
		 'module_items', 1,
sub
#line 334 "verilog.yapp"
{ f ("module_items", $_[1]) }
	],
	[#Rule 72
		 'module_items', 2,
sub
#line 335 "verilog.yapp"
{ list (@_[1..$#_]) }
	],
	[#Rule 73
		 'module_item', 2,
sub
#line 338 "verilog.yapp"
{ $_[1]->append_text ($_[2]) }
	],
	[#Rule 74
		 'module_item', 1, undef
	],
	[#Rule 75
		 'module_or_generate_item', 2,
sub
#line 343 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 76
		 'module_or_generate_item', 2,
sub
#line 344 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 77
		 'module_or_generate_item', 2,
sub
#line 345 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 78
		 'module_or_generate_item', 2,
sub
#line 346 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 79
		 'module_or_generate_item', 2,
sub
#line 347 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 80
		 'module_or_generate_item', 2,
sub
#line 348 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 81
		 'module_or_generate_item', 1, undef
	],
	[#Rule 82
		 'module_or_generate_item_declaration', 1, undef
	],
	[#Rule 83
		 'module_or_generate_item_declaration', 1, undef
	],
	[#Rule 84
		 'module_or_generate_item_declaration', 1, undef
	],
	[#Rule 85
		 'module_or_generate_item_declaration', 1, undef
	],
	[#Rule 86
		 'module_or_generate_item_declaration', 1, undef
	],
	[#Rule 87
		 'module_or_generate_item_declaration', 1, undef
	],
	[#Rule 88
		 'module_or_generate_item_declaration', 1, undef
	],
	[#Rule 89
		 'module_or_generate_item_declaration', 1, undef
	],
	[#Rule 90
		 'module_or_generate_item_declaration', 1, undef
	],
	[#Rule 91
		 'module_or_generate_item_declaration', 1, undef
	],
	[#Rule 92
		 'opt_non_port_module_items', 0,
sub
#line 364 "verilog.yapp"
{ null }
	],
	[#Rule 93
		 'opt_non_port_module_items', 1, undef
	],
	[#Rule 94
		 'non_port_module_items', 1,
sub
#line 368 "verilog.yapp"
{ VP3::ParseTree->factory ("module_items", $_[1]) }
	],
	[#Rule 95
		 'non_port_module_items', 2,
sub
#line 369 "verilog.yapp"
{ $_[1]->append_children ($_[2]) }
	],
	[#Rule 96
		 'non_port_module_item', 1, undef
	],
	[#Rule 97
		 'non_port_module_item', 1, undef
	],
	[#Rule 98
		 'non_port_module_item', 1, undef
	],
	[#Rule 99
		 'non_port_module_item', 2,
sub
#line 378 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 100
		 'non_port_module_item', 2,
sub
#line 379 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 101
		 'non_port_module_item', 2,
sub
#line 380 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 102
		 'parameter_override', 3,
sub
#line 383 "verilog.yapp"
{ $_[2]->prepend_text ($_[1])->append_text ($_[3]); f ("parameter_override", $_[2]) }
	],
	[#Rule 103
		 'local_parameter_declaration', 4,
sub
#line 398 "verilog.yapp"
{
                                   $_[2]->prepend_text ($_[1]);
                                   $_[0]->decl (f ("parameter_declaration", "localparam", @_[2,3,4]));
                               }
	],
	[#Rule 104
		 'local_parameter_declaration', 3,
sub
#line 405 "verilog.yapp"
{
                                   $_[2]->prepend_text ($_[1]);
                                   $_[0]->decl (f ("parameter_declaration", "localparam", $_[2], null, $_[3]));
                               }
	],
	[#Rule 105
		 'pdc_parameter_declaration', 4,
sub
#line 420 "verilog.yapp"
{
                                 $_[2]->prepend_text ($_[1]);
                                 $_[0]->decl (f ("parameter_declaration", "parameter", @_[2,3,4]));
                             }
	],
	[#Rule 106
		 'pdc_parameter_declaration', 3,
sub
#line 427 "verilog.yapp"
{
                                 $_[2]->prepend_text ($_[1]);
                                 $_[0]->decl (f ("parameter_declaration", "parameter", $_[2], null, $_[3]));
                             }
	],
	[#Rule 107
		 'pdp_parameter_declaration', 4,
sub
#line 437 "verilog.yapp"
{
                                 $_[2]->prepend_text ($_[1]);
                                 $_[0]->decl (f ("parameter_declaration", "parameter", @_[2,3,4]));
                             }
	],
	[#Rule 108
		 'pdp_parameter_declaration', 3,
sub
#line 444 "verilog.yapp"
{
                                 $_[2]->prepend_text ($_[1]);
                                 $_[0]->decl (f ("parameter_declaration", "parameter", $_[2], null, $_[3]));
                             }
	],
	[#Rule 109
		 'pds_parameter_declaration', 4,
sub
#line 454 "verilog.yapp"
{
                                 $_[2]->prepend_text ($_[1]);
                                 $_[0]->decl (f ("parameter_declaration", "parameter", @_[2,3,4]));
                             }
	],
	[#Rule 110
		 'pds_parameter_declaration', 3,
sub
#line 461 "verilog.yapp"
{
                                 $_[2]->prepend_text ($_[1]);
                                 $_[0]->decl (f ("parameter_declaration", "parameter", $_[2], null, $_[3]));
                             }
	],
	[#Rule 111
		 'specparam_declaration', 4,
sub
#line 467 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]);
                                                                                 $_[3]->append_text ($_[4]);
                                                                                 f ("specparam_declaration", @_[2,3]) }
	],
	[#Rule 112
		 'parameter_type', 1, undef
	],
	[#Rule 113
		 'parameter_type', 1, undef
	],
	[#Rule 114
		 'parameter_type', 1, undef
	],
	[#Rule 115
		 'parameter_type', 1, undef
	],
	[#Rule 116
		 'input_type', 2,
sub
#line 484 "verilog.yapp"
{ f ("input_type", null , $_[1], $_[2]) }
	],
	[#Rule 117
		 'input_type', 3,
sub
#line 485 "verilog.yapp"
{ f ("input_type", $_[1], $_[2], $_[3]) }
	],
	[#Rule 118
		 'pip_input_declaration', 3,
sub
#line 489 "verilog.yapp"
{
                             $_[3] = f ("list_of_port_identifiers", $_[3]);
                             $_[0]->decl (f ("input_declaration", @_[1..3]));
                         }
	],
	[#Rule 119
		 'pip_input_declaration', 4,
sub
#line 494 "verilog.yapp"
{
                             $_[3]->append_children ($_[4]);
                             $_[0]->decl (f ("input_declaration", @_[1..3]));
                         }
	],
	[#Rule 120
		 'pic_input_declaration', 3,
sub
#line 500 "verilog.yapp"
{ $_[0]->decl (f ("input_declaration", @_[1..$#_])); }
	],
	[#Rule 121
		 'input_declaration', 3,
sub
#line 503 "verilog.yapp"
{ $_[0]->decl (f ("input_declaration", @_[1..$#_])) }
	],
	[#Rule 122
		 'pip_inout_declaration', 3,
sub
#line 507 "verilog.yapp"
{
                             $_[3] = f ("list_of_port_identifiers", $_[3]);
                             $_[0]->decl (f ("inout_declaration", @_[1..3]));
                         }
	],
	[#Rule 123
		 'pip_inout_declaration', 4,
sub
#line 512 "verilog.yapp"
{
                             $_[3]->append_children ($_[4]);
                             $_[0]->decl (f ("inout_declaration", @_[1..3]));
                         }
	],
	[#Rule 124
		 'pic_inout_declaration', 3,
sub
#line 518 "verilog.yapp"
{ $_[0]->decl (f ("inout_declaration", @_[1..$#_])); }
	],
	[#Rule 125
		 'inout_declaration', 3,
sub
#line 521 "verilog.yapp"
{ $_[0]->decl (f ("inout_declaration", @_[1..$#_])) }
	],
	[#Rule 126
		 'output_net_type', 2,
sub
#line 524 "verilog.yapp"
{ f ("output_type", null , $_[1], $_[2]) }
	],
	[#Rule 127
		 'output_net_type', 3,
sub
#line 525 "verilog.yapp"
{ f ("output_type", $_[1], $_[2], $_[3]) }
	],
	[#Rule 128
		 'output_var_type', 3,
sub
#line 528 "verilog.yapp"
{ f ("output_type", $_[1], $_[2], $_[3]) }
	],
	[#Rule 129
		 'output_var_type', 1,
sub
#line 529 "verilog.yapp"
{ f ("output_type", $_[1], null , null ) }
	],
	[#Rule 130
		 'output_var_type', 1,
sub
#line 530 "verilog.yapp"
{ f ("output_type", $_[1], null , null ) }
	],
	[#Rule 131
		 'pip_output_declaration', 3,
sub
#line 534 "verilog.yapp"
{
                              $_[3] = f ("list_of_port_identifiers", $_[3]);
                              $_[0]->decl (f ("output_declaration", @_[1..3]));
                          }
	],
	[#Rule 132
		 'pip_output_declaration', 3,
sub
#line 539 "verilog.yapp"
{
                              $_[3] = f ("list_of_variable_port_identifiers", $_[3]);
                              $_[0]->decl (f ("output_declaration", @_[1..3]));
                          }
	],
	[#Rule 133
		 'pip_output_declaration', 4,
sub
#line 544 "verilog.yapp"
{
                              $_[3]->append_children ($_[4]);
                              $_[0]->decl (f ("output_declaration", @_[1..3]));
                          }
	],
	[#Rule 134
		 'pip_output_declaration', 4,
sub
#line 549 "verilog.yapp"
{
                              $_[3]->append_children ($_[4]);
                              $_[0]->decl (f ("output_declaration", @_[1..3]));
                          }
	],
	[#Rule 135
		 'pic_output_declaration', 3,
sub
#line 555 "verilog.yapp"
{ $_[0]->decl (f ("output_declaration", @_[1..$#_])) }
	],
	[#Rule 136
		 'pic_output_declaration', 3,
sub
#line 556 "verilog.yapp"
{ $_[0]->decl (f ("output_declaration", @_[1..$#_])) }
	],
	[#Rule 137
		 'output_declaration', 3,
sub
#line 559 "verilog.yapp"
{ $_[0]->decl (f ("output_declaration", @_[1..$#_])) }
	],
	[#Rule 138
		 'output_declaration', 3,
sub
#line 560 "verilog.yapp"
{ $_[0]->decl (f ("output_declaration", @_[1..$#_])) }
	],
	[#Rule 139
		 'event_declaration', 3,
sub
#line 565 "verilog.yapp"
{ $_[2]->prepend_text ($_[1])->append_text ($_[3]);
                                                           $_[0]->decl (f ("event_declaration", $_[2])) }
	],
	[#Rule 140
		 'genvar_declaration', 3,
sub
#line 570 "verilog.yapp"
{
                        $_[2]->prepend_text ($_[1]);
                        $_[2]->append_text ($_[3]);
                        $_[0]->decl (f ("genvar_declaration", $_[2]))
                    }
	],
	[#Rule 141
		 'integer_declaration', 3,
sub
#line 577 "verilog.yapp"
{ $_[2]->prepend_text ($_[1])->append_text ($_[3]);
                                                                  $_[0]->decl (f ("integer_declaration", $_[2])) }
	],
	[#Rule 142
		 'vectored_or_scalared', 1, undef
	],
	[#Rule 143
		 'vectored_or_scalared', 1, undef
	],
	[#Rule 144
		 'net_declaration', 5,
sub
#line 585 "verilog.yapp"
{ $_[4]->append_text ($_[5]); $_[0]->decl (f ("net_declaration", $_[1],  null,  null, $_[2],  null, $_[3], $_[4])); }
	],
	[#Rule 145
		 'net_declaration', 5,
sub
#line 586 "verilog.yapp"
{ $_[4]->append_text ($_[5]); $_[0]->decl (f ("net_declaration", $_[1],  null,  null, $_[2],  null, $_[3], $_[4])); }
	],
	[#Rule 146
		 'net_declaration', 6,
sub
#line 587 "verilog.yapp"
{ $_[5]->append_text ($_[6]); $_[0]->decl (f ("net_declaration", $_[1], $_[2],  null, $_[3],  null, $_[4], $_[5])); }
	],
	[#Rule 147
		 'net_declaration', 6,
sub
#line 588 "verilog.yapp"
{ $_[5]->append_text ($_[6]); $_[0]->decl (f ("net_declaration", $_[1],  null,  null, $_[2], $_[3], $_[4], $_[5])); }
	],
	[#Rule 148
		 'net_declaration', 7,
sub
#line 589 "verilog.yapp"
{ $_[6]->append_text ($_[7]); $_[0]->decl (f ("net_declaration", $_[1],  null, $_[2], $_[3], $_[4], $_[5], $_[6])); }
	],
	[#Rule 149
		 'net_declaration', 6,
sub
#line 590 "verilog.yapp"
{ $_[5]->append_text ($_[6]); $_[0]->decl (f ("net_declaration", $_[1],  null,  null, $_[2], $_[3], $_[4], $_[5])); }
	],
	[#Rule 150
		 'net_declaration', 7,
sub
#line 591 "verilog.yapp"
{ $_[6]->append_text ($_[7]); $_[0]->decl (f ("net_declaration", $_[1], $_[2],  null, $_[3], $_[4], $_[5], $_[6])); }
	],
	[#Rule 151
		 'net_declaration', 7,
sub
#line 592 "verilog.yapp"
{ $_[6]->append_text ($_[7]); $_[0]->decl (f ("net_declaration", $_[1],  null, $_[2], $_[3], $_[4], $_[5], $_[6])); }
	],
	[#Rule 152
		 'net_declaration', 8,
sub
#line 593 "verilog.yapp"
{ $_[7]->append_text ($_[8]); $_[0]->decl (f ("net_declaration", $_[1], $_[2], $_[3], $_[4], $_[5], $_[6], $_[7])); }
	],
	[#Rule 153
		 'net_declaration', 5,
sub
#line 595 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); $_[4]->append_text ($_[5]); $_[0]->decl (f ("trireg_declaration",  null,  null,  null, $_[2],  null, $_[3], $_[4])) }
	],
	[#Rule 154
		 'net_declaration', 6,
sub
#line 596 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); $_[5]->append_text ($_[6]); $_[0]->decl (f ("trireg_declaration",  null, $_[2],  null, $_[3],  null, $_[4], $_[5])) }
	],
	[#Rule 155
		 'net_declaration', 5,
sub
#line 597 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); $_[4]->append_text ($_[5]); $_[0]->decl (f ("trireg_declaration",  null,  null,  null, $_[2],  null, $_[3], $_[4])) }
	],
	[#Rule 156
		 'net_declaration', 6,
sub
#line 598 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); $_[5]->append_text ($_[6]); $_[0]->decl (f ("trireg_declaration", $_[2],  null,  null, $_[3],  null, $_[4], $_[5])) }
	],
	[#Rule 157
		 'net_declaration', 6,
sub
#line 600 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); $_[5]->append_text ($_[6]); $_[0]->decl (f ("trireg_declaration",  null,  null,  null, $_[2], $_[3], $_[4], $_[5])) }
	],
	[#Rule 158
		 'net_declaration', 7,
sub
#line 601 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); $_[6]->append_text ($_[7]); $_[0]->decl (f ("trireg_declaration",  null, $_[2],  null, $_[3], $_[4], $_[5], $_[6])) }
	],
	[#Rule 159
		 'net_declaration', 7,
sub
#line 602 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); $_[6]->append_text ($_[7]); $_[0]->decl (f ("trireg_declaration",  null,  null, $_[2], $_[3], $_[4], $_[5], $_[6])) }
	],
	[#Rule 160
		 'net_declaration', 8,
sub
#line 603 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); $_[7]->append_text ($_[8]); $_[0]->decl (f ("trireg_declaration",  null, $_[2], $_[3], $_[4], $_[5], $_[6], $_[7])) }
	],
	[#Rule 161
		 'net_declaration', 6,
sub
#line 605 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); $_[5]->append_text ($_[6]); $_[0]->decl (f ("trireg_declaration",  null,  null,  null, $_[2], $_[3], $_[4], $_[5])) }
	],
	[#Rule 162
		 'net_declaration', 7,
sub
#line 606 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); $_[6]->append_text ($_[7]); $_[0]->decl (f ("trireg_declaration", $_[2],  null,  null, $_[3], $_[4], $_[5], $_[6])) }
	],
	[#Rule 163
		 'net_declaration', 7,
sub
#line 607 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); $_[6]->append_text ($_[7]); $_[0]->decl (f ("trireg_declaration",  null,  null, $_[2], $_[3], $_[4], $_[5], $_[6])) }
	],
	[#Rule 164
		 'net_declaration', 8,
sub
#line 608 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); $_[7]->append_text ($_[8]); $_[0]->decl (f ("trireg_declaration", $_[2],  null, $_[3], $_[4], $_[5], $_[6], $_[7])) }
	],
	[#Rule 165
		 'real_declaration', 3,
sub
#line 612 "verilog.yapp"
{
                        $_[2]->prepend_text ($_[1]);
                        $_[2]->append_text ($_[3]);
                        $_[0]->decl (f ("real_declaration", $_[2]))
                    }
	],
	[#Rule 166
		 'realtime_declaration', 3,
sub
#line 620 "verilog.yapp"
{
                        $_[2]->prepend_text ($_[1]);
                        $_[2]->append_text ($_[3]);
                        $_[0]->decl (f ("realtime_declaration", $_[2]))
                    }
	],
	[#Rule 167
		 'reg_declaration', 5,
sub
#line 628 "verilog.yapp"
{
                       $_[2]->prepend_text ($_[1]);
                       $_[4]->append_text ($_[5]);
                       $_[0]->decl (f ("reg_declaration", @_[2,3,4]));;
                   }
	],
	[#Rule 168
		 'time_declaration', 3,
sub
#line 636 "verilog.yapp"
{
                      $_[2]->prepend_text ($_[1]);
                      $_[2]->append_text ($_[3]);
                      $_[0]->decl (f ("time_declaration", $_[2]))
                  }
	],
	[#Rule 169
		 'net_type', 1, undef
	],
	[#Rule 170
		 'net_type', 1, undef
	],
	[#Rule 171
		 'net_type', 1, undef
	],
	[#Rule 172
		 'net_type', 1, undef
	],
	[#Rule 173
		 'net_type', 1, undef
	],
	[#Rule 174
		 'net_type', 1, undef
	],
	[#Rule 175
		 'net_type', 1, undef
	],
	[#Rule 176
		 'net_type', 1, undef
	],
	[#Rule 177
		 'net_type', 1, undef
	],
	[#Rule 178
		 'net_type', 1, undef
	],
	[#Rule 179
		 'opt_constant_assignment', 0,
sub
#line 651 "verilog.yapp"
{ null }
	],
	[#Rule 180
		 'opt_constant_assignment', 2,
sub
#line 652 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 181
		 'real_type', 2,
sub
#line 655 "verilog.yapp"
{ f ("real_type", @_[1..$#_]) }
	],
	[#Rule 182
		 'real_type', 2,
sub
#line 656 "verilog.yapp"
{ f ("real_type", @_[1..$#_]) }
	],
	[#Rule 183
		 'variable_type', 2,
sub
#line 659 "verilog.yapp"
{ f ("variable_type", @_[1..$#_]) }
	],
	[#Rule 184
		 'variable_type', 2,
sub
#line 660 "verilog.yapp"
{ f ("variable_type", @_[1..$#_]) }
	],
	[#Rule 185
		 'opt_drive_strength', 0,
sub
#line 665 "verilog.yapp"
{ null }
	],
	[#Rule 186
		 'opt_drive_strength', 1, undef
	],
	[#Rule 187
		 'drive_strength', 5,
sub
#line 669 "verilog.yapp"
{ drive_strength (@_) }
	],
	[#Rule 188
		 'drive_strength', 5,
sub
#line 670 "verilog.yapp"
{ drive_strength (@_) }
	],
	[#Rule 189
		 'drive_strength', 5,
sub
#line 671 "verilog.yapp"
{ drive_strength (@_) }
	],
	[#Rule 190
		 'drive_strength', 5,
sub
#line 672 "verilog.yapp"
{ drive_strength (@_) }
	],
	[#Rule 191
		 'drive_strength', 5,
sub
#line 673 "verilog.yapp"
{ drive_strength (@_) }
	],
	[#Rule 192
		 'drive_strength', 5,
sub
#line 674 "verilog.yapp"
{ drive_strength (@_) }
	],
	[#Rule 193
		 'strength0', 1, undef
	],
	[#Rule 194
		 'strength0', 1, undef
	],
	[#Rule 195
		 'strength0', 1, undef
	],
	[#Rule 196
		 'strength0', 1, undef
	],
	[#Rule 197
		 'strength1', 1, undef
	],
	[#Rule 198
		 'strength1', 1, undef
	],
	[#Rule 199
		 'strength1', 1, undef
	],
	[#Rule 200
		 'strength1', 1, undef
	],
	[#Rule 201
		 'charge_strength', 3,
sub
#line 687 "verilog.yapp"
{ charge_strength (@_) }
	],
	[#Rule 202
		 'charge_strength', 3,
sub
#line 688 "verilog.yapp"
{ charge_strength (@_) }
	],
	[#Rule 203
		 'charge_strength', 3,
sub
#line 689 "verilog.yapp"
{ charge_strength (@_) }
	],
	[#Rule 204
		 'opt_delay3', 0,
sub
#line 694 "verilog.yapp"
{ null }
	],
	[#Rule 205
		 'opt_delay3', 1, undef
	],
	[#Rule 206
		 'delay3', 2,
sub
#line 698 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); f ("delay", $_[2]) }
	],
	[#Rule 207
		 'delay3', 4,
sub
#line 699 "verilog.yapp"
{ $_[3]->prepend_text ($_[2])->prepend_text ($_[1]); $_[3]->append_text ($_[4]);                                                         f ("delay", $_[3]    ) }
	],
	[#Rule 208
		 'delay3', 6,
sub
#line 700 "verilog.yapp"
{ $_[3]->prepend_text ($_[2])->prepend_text ($_[1]); $_[3]->append_text ($_[4]); $_[5]->append_text ($_[6]);                             f ("delay", @_[3,5]  ) }
	],
	[#Rule 209
		 'delay3', 8,
sub
#line 701 "verilog.yapp"
{ $_[3]->prepend_text ($_[2])->prepend_text ($_[1]); $_[3]->append_text ($_[4]); $_[5]->append_text ($_[6]); $_[7]->append_text ($_[8]); f ("delay", @_[3,5,7]) }
	],
	[#Rule 210
		 'delay_value', 1, undef
	],
	[#Rule 211
		 'delay_value', 1, undef
	],
	[#Rule 212
		 'delay_value', 1, undef
	],
	[#Rule 213
		 'list_of_defparam_assignments', 1,
sub
#line 721 "verilog.yapp"
{ f ("list_of_defparam_assignments", $_[1]) }
	],
	[#Rule 214
		 'list_of_defparam_assignments', 3,
sub
#line 722 "verilog.yapp"
{ list_delim (@_[1..$#_]) }
	],
	[#Rule 215
		 'event_identifier_dimensions', 2,
sub
#line 725 "verilog.yapp"
{ f ("event_identifier_dimensions", @_[1..$#_]) }
	],
	[#Rule 216
		 'list_of_event_identifiers', 1,
sub
#line 728 "verilog.yapp"
{ f ("list_of_event_identifiers", $_[1]) }
	],
	[#Rule 217
		 'list_of_event_identifiers', 3,
sub
#line 729 "verilog.yapp"
{ list_delim (@_[1..$#_]) }
	],
	[#Rule 218
		 'list_of_genvar_identifiers', 1,
sub
#line 732 "verilog.yapp"
{ f ("list_of_genvar_identifiers", $_[1]) }
	],
	[#Rule 219
		 'list_of_genvar_identifiers', 3,
sub
#line 733 "verilog.yapp"
{ list_delim (@_[1..$#_]) }
	],
	[#Rule 220
		 'list_of_net_decl_assignments', 1,
sub
#line 736 "verilog.yapp"
{ f ("list_of_net_decl_assignments", $_[1]) }
	],
	[#Rule 221
		 'list_of_net_decl_assignments', 3,
sub
#line 737 "verilog.yapp"
{ list_delim (@_[1..$#_]) }
	],
	[#Rule 222
		 'net_identifier_dimensions', 2,
sub
#line 740 "verilog.yapp"
{ f ("net_identifier_dimensions", @_[1..$#_]) }
	],
	[#Rule 223
		 'list_of_net_identifiers', 1,
sub
#line 743 "verilog.yapp"
{ f ("list_of_net_identifiers", $_[1]) }
	],
	[#Rule 224
		 'list_of_net_identifiers', 3,
sub
#line 744 "verilog.yapp"
{ list_delim (@_[1..$#_]) }
	],
	[#Rule 225
		 'pac_param_assignment', 2,
sub
#line 754 "verilog.yapp"
{ $_[1]->append_text ($_[2]) }
	],
	[#Rule 226
		 'pac_param_assignments', 1,
sub
#line 757 "verilog.yapp"
{ f ("list_of_param_assignments", $_[1]) }
	],
	[#Rule 227
		 'pac_param_assignments', 2,
sub
#line 758 "verilog.yapp"
{ list (@_[1..$#_]) }
	],
	[#Rule 228
		 'pap_param_assignment', 2,
sub
#line 761 "verilog.yapp"
{ $_[1]->append_text ($_[2]) }
	],
	[#Rule 229
		 'pap_param_assignments', 1,
sub
#line 764 "verilog.yapp"
{ f ("list_of_param_assignments", $_[1]) }
	],
	[#Rule 230
		 'pap_param_assignments', 2,
sub
#line 765 "verilog.yapp"
{ $_[1]->append_children ($_[2]) }
	],
	[#Rule 231
		 'pas_param_assignment', 2,
sub
#line 768 "verilog.yapp"
{ $_[1]->append_text ($_[2]) }
	],
	[#Rule 232
		 'pas_param_assignments', 1,
sub
#line 771 "verilog.yapp"
{ f ("list_of_param_assignments", $_[1]) }
	],
	[#Rule 233
		 'pas_param_assignments', 2,
sub
#line 772 "verilog.yapp"
{ $_[1]->append_children ($_[2]) }
	],
	[#Rule 234
		 'list_of_port_identifiers', 1,
sub
#line 779 "verilog.yapp"
{ f ("list_of_port_identifiers", $_[1]) }
	],
	[#Rule 235
		 'list_of_port_identifiers', 3,
sub
#line 780 "verilog.yapp"
{ list_delim (@_[1..$#_]) }
	],
	[#Rule 236
		 'list_of_real_identifiers', 1,
sub
#line 783 "verilog.yapp"
{ f ("list_of_real_identifiers", $_[1]) }
	],
	[#Rule 237
		 'list_of_real_identifiers', 3,
sub
#line 784 "verilog.yapp"
{ list_delim (@_[1..$#_]) }
	],
	[#Rule 238
		 'list_of_specparam_assignments', 1,
sub
#line 787 "verilog.yapp"
{ f ("list_of_specparam_assignments", $_[1]) }
	],
	[#Rule 239
		 'list_of_specparam_assignments', 3,
sub
#line 788 "verilog.yapp"
{ list_delim (@_[1..$#_]) }
	],
	[#Rule 240
		 'list_of_variable_identifiers', 1,
sub
#line 791 "verilog.yapp"
{ f ("list_of_variable_identifiers", $_[1]) }
	],
	[#Rule 241
		 'list_of_variable_identifiers', 3,
sub
#line 792 "verilog.yapp"
{ list_delim (@_[1..$#_]) }
	],
	[#Rule 242
		 'variable_port_identifier', 2,
sub
#line 795 "verilog.yapp"
{ f ("variable_port_identifier", @_[1,2]) }
	],
	[#Rule 243
		 'list_of_variable_port_identifiers', 1,
sub
#line 798 "verilog.yapp"
{ f ("list_of_variable_port_identifiers", $_[1]) }
	],
	[#Rule 244
		 'list_of_variable_port_identifiers', 3,
sub
#line 799 "verilog.yapp"
{ list_delim (@_[1..$#_]) }
	],
	[#Rule 245
		 'defparam_assignment', 3,
sub
#line 804 "verilog.yapp"
{ $_[1]->append_text ($_[2]); f ("defparam_assignment", @_[1,3]) }
	],
	[#Rule 246
		 'net_decl_assignment', 3,
sub
#line 807 "verilog.yapp"
{ $_[1]->append_text ($_[2]); f ("assignment", "continuous", $_[1], null, $_[3]) }
	],
	[#Rule 247
		 'param_assignment', 3,
sub
#line 810 "verilog.yapp"
{ $_[1]->append_text ($_[2]); f ("param_assignment", $_[1], $_[3]); }
	],
	[#Rule 248
		 'specparam_assignment', 3,
sub
#line 813 "verilog.yapp"
{ $_[1]->append_text ($_[2]); f ("specparam_assignment", @_[1,3]) }
	],
	[#Rule 249
		 'specparam_assignment', 1, undef
	],
	[#Rule 250
		 'pulse_control_specparam', 6,
sub
#line 819 "verilog.yapp"
{ $_[4]->prepend_text ($_[3])->prepend_text ($_[2])->prepend_text ($_[1]);
                                                                                                                                                                            $_[4]->append_text ($_[5])->append_text ($_[6]);
                                                                                                                                                                            f ("pulse_control_specparam", null , null , $_[4], null ) }
	],
	[#Rule 251
		 'pulse_control_specparam', 8,
sub
#line 822 "verilog.yapp"
{ $_[4]->prepend_text ($_[3])->prepend_text ($_[2])->prepend_text ($_[1]);
                                                                                                                                                                            $_[4]->append_text ($_[5]);
                                                                                                                                                                            $_[6]->append_text ($_[7])->append_text ($_[8]);
                                                                                                                                                                            f ("pulse_control_specparam", null , null , $_[4], $_[6]) }
	],
	[#Rule 252
		 'pulse_control_specparam', 9,
sub
#line 826 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]);
                                                                                                                                                                            $_[4]->prepend_text ($_[3]);
                                                                                                                                                                            $_[7]->prepend_text ($_[6])->prepend_text ($_[5]);
                                                                                                                                                                            $_[7]->append_text ($_[8])->append_text ($_[9]);
                                                                                                                                                                            f ("pulse_control_specparam", $_[2], $_[4], $_[7], null ) }
	],
	[#Rule 253
		 'pulse_control_specparam', 11,
sub
#line 831 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]);
                                                                                                                                                                            $_[4]->prepend_text ($_[3]);
                                                                                                                                                                            $_[7]->prepend_text ($_[6])->prepend_text ($_[5]);
                                                                                                                                                                            $_[7]->append_text ($_[8]);
                                                                                                                                                                            $_[9]->append_text ($_[10])->append_text ($_[11]);
                                                                                                                                                                            f ("pulse_control_specparam", $_[2], $_[4], $_[7], $_[9]) }
	],
	[#Rule 254
		 'error_limit_value', 1, undef
	],
	[#Rule 255
		 'reject_limit_value', 1, undef
	],
	[#Rule 256
		 'limit_value', 1, undef
	],
	[#Rule 257
		 'opt_dimensions', 0,
sub
#line 845 "verilog.yapp"
{ null }
	],
	[#Rule 258
		 'opt_dimensions', 1, undef
	],
	[#Rule 259
		 'dimensions', 1,
sub
#line 849 "verilog.yapp"
{ f ("dimensions", $_[1]) }
	],
	[#Rule 260
		 'dimensions', 2,
sub
#line 850 "verilog.yapp"
{ $_[1]->append_children ($_[2]) }
	],
	[#Rule 261
		 'dimension', 5,
sub
#line 853 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]);
                                                                                     $_[4]->prepend_text ($_[3]);
                                                                                     $_[4]->append_text ($_[5]);
                                                                                     f ("dimension", @_[2,4]) }
	],
	[#Rule 262
		 'opt_range', 0,
sub
#line 859 "verilog.yapp"
{ null }
	],
	[#Rule 263
		 'opt_range', 1, undef
	],
	[#Rule 264
		 'range', 5,
sub
#line 865 "verilog.yapp"
{ $_[2]->prepend_text ($_[1])->append_text ($_[3]);
                                                                     $_[4]->append_text ($_[5]);
                                                                     f ("range", @_[2,4]) }
	],
	[#Rule 265
		 'function_declaration', 9,
sub
#line 881 "verilog.yapp"
{
                            $_[2]->prepend_text ($_[1]);
                            $_[5]->append_text ($_[6]);
                            $_[8]->append_text ($_[9]);
                            f ("function_declaration", @_[2,3,4,5], null, @_[7,8])
                        }
	],
	[#Rule 266
		 'function_declaration', 10,
sub
#line 891 "verilog.yapp"
{
                            $_[2]->prepend_text ($_[1]);
                            $_[7]->prepend_text ($_[6]);
                            $_[7]->append_text ($_[8]);
                            $_[9]->append_text ($_[10]);
                            f ("function_declaration", @_[2,3,4,5,7], null, $_[9])
                        }
	],
	[#Rule 267
		 'function_declaration', 11,
sub
#line 903 "verilog.yapp"
{
                            $_[2]->prepend_text ($_[1]);
                            $_[7]->prepend_text ($_[6]);
                            $_[7]->append_text ($_[8]);
                            $_[10]->append_text ($_[11]);
                            f ("function_declaration", @_[2,3,4,5,7,9,10])
                        }
	],
	[#Rule 268
		 'function_item_declarations', 1,
sub
#line 912 "verilog.yapp"
{ f ("function_item_declarations", $_[1]) }
	],
	[#Rule 269
		 'function_item_declarations', 2,
sub
#line 913 "verilog.yapp"
{ list (@_[1..$#_]) }
	],
	[#Rule 270
		 'function_item_declaration', 1, undef
	],
	[#Rule 271
		 'function_item_declaration', 3,
sub
#line 917 "verilog.yapp"
{ $_[2]->prepend_text ($_[1])->append_text ($_[3]) }
	],
	[#Rule 272
		 'function_port_list', 1,
sub
#line 921 "verilog.yapp"
{ f ("function_port_list", $_[1]) }
	],
	[#Rule 273
		 'function_port_list', 2,
sub
#line 922 "verilog.yapp"
{ list (@_[1,2]) }
	],
	[#Rule 274
		 'pip_function_port', 2,
sub
#line 928 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 275
		 'pic_function_ports', 1,
sub
#line 931 "verilog.yapp"
{ f ("function_port_list", $_[1]) }
	],
	[#Rule 276
		 'pic_function_ports', 2,
sub
#line 932 "verilog.yapp"
{ list (@_[1,2]) }
	],
	[#Rule 277
		 'pic_function_port', 2,
sub
#line 935 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 278
		 'opt_range_or_type', 0,
sub
#line 938 "verilog.yapp"
{ null }
	],
	[#Rule 279
		 'opt_range_or_type', 1, undef
	],
	[#Rule 280
		 'range_or_type', 1, undef
	],
	[#Rule 281
		 'range_or_type', 1, undef
	],
	[#Rule 282
		 'range_or_type', 1, undef
	],
	[#Rule 283
		 'range_or_type', 1, undef
	],
	[#Rule 284
		 'range_or_type', 1, undef
	],
	[#Rule 285
		 'task_declaration', 7,
sub
#line 957 "verilog.yapp"
{
                        $_[2]->prepend_text ($_[1]);
                        $_[3]->append_text ($_[4]);
                        $_[6]->append_text ($_[7]);
                        f ("task_declaration", @_[2,3], null, @_[5,6])
                    }
	],
	[#Rule 286
		 'task_declaration', 8,
sub
#line 966 "verilog.yapp"
{
                        $_[2]->prepend_text ($_[1]);
                        $_[5]->prepend_text ($_[4]);
                        $_[5]->append_text ($_[6]);
                        $_[7]->append_text ($_[8]);
                        f ("task_declaration", @_[2,3,5], null, $_[7])
                    }
	],
	[#Rule 287
		 'task_declaration', 9,
sub
#line 977 "verilog.yapp"
{
                        $_[2]->prepend_text ($_[1]);
                        $_[5]->prepend_text ($_[4]);
                        $_[5]->append_text ($_[6]);
                        $_[8]->append_text ($_[9]);
                        f ("task_declaration", @_[2,3,5,7,8])
                    }
	],
	[#Rule 288
		 'task_item_declarations', 1,
sub
#line 986 "verilog.yapp"
{ f ("task_item_declarations", $_[1]) }
	],
	[#Rule 289
		 'task_item_declarations', 2,
sub
#line 987 "verilog.yapp"
{ list (@_[1..$#_]) }
	],
	[#Rule 290
		 'task_item_declaration', 1, undef
	],
	[#Rule 291
		 'task_item_declaration', 3,
sub
#line 991 "verilog.yapp"
{ $_[2]->prepend_text ($_[1])->append_text ($_[3]) }
	],
	[#Rule 292
		 'task_item_declaration', 3,
sub
#line 992 "verilog.yapp"
{ $_[2]->prepend_text ($_[1])->append_text ($_[3]) }
	],
	[#Rule 293
		 'task_item_declaration', 3,
sub
#line 993 "verilog.yapp"
{ $_[2]->prepend_text ($_[1])->append_text ($_[3]) }
	],
	[#Rule 294
		 'task_port_list', 1,
sub
#line 997 "verilog.yapp"
{ f ("task_port_list", "")->append_text ($_[1]) }
	],
	[#Rule 295
		 'task_port_list', 1,
sub
#line 998 "verilog.yapp"
{ f ("task_port_list", $_[1]) }
	],
	[#Rule 296
		 'task_port_list', 2,
sub
#line 999 "verilog.yapp"
{ list (@_[1..2]) }
	],
	[#Rule 297
		 'pip_task_port_item', 2,
sub
#line 1007 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 298
		 'pip_task_port_item', 2,
sub
#line 1008 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 299
		 'pip_task_port_item', 2,
sub
#line 1009 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 300
		 'pic_task_port_items', 1,
sub
#line 1012 "verilog.yapp"
{ f ("task_port_list", $_[1]) }
	],
	[#Rule 301
		 'pic_task_port_items', 2,
sub
#line 1013 "verilog.yapp"
{ list (@_[1,2]) }
	],
	[#Rule 302
		 'pic_task_port_item', 2,
sub
#line 1016 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 303
		 'pic_task_port_item', 2,
sub
#line 1017 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 304
		 'pic_task_port_item', 2,
sub
#line 1018 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 305
		 'pip_tf_input_declaration', 3,
sub
#line 1021 "verilog.yapp"
{ f ("tf_input_declaration", @_[1..$#_]) }
	],
	[#Rule 306
		 'pip_tf_input_declaration', 4,
sub
#line 1022 "verilog.yapp"
{ f ("tf_input_declaration", @_[1..$#_]) }
	],
	[#Rule 307
		 'pic_tf_input_declaration', 3,
sub
#line 1025 "verilog.yapp"
{ f ("tf_input_declaration", @_[1..$#_]) }
	],
	[#Rule 308
		 'tf_input_declaration', 3,
sub
#line 1028 "verilog.yapp"
{ f ("tf_input_declaration", @_[1..$#_]) }
	],
	[#Rule 309
		 'pip_tf_output_declaration', 3,
sub
#line 1031 "verilog.yapp"
{ f ("tf_output_declaration", @_[1..$#_]) }
	],
	[#Rule 310
		 'pip_tf_output_declaration', 4,
sub
#line 1032 "verilog.yapp"
{ f ("tf_output_declaration", @_[1..$#_]) }
	],
	[#Rule 311
		 'pic_tf_output_declaration', 3,
sub
#line 1035 "verilog.yapp"
{ f ("tf_output_declaration", @_[1..$#_]) }
	],
	[#Rule 312
		 'tf_output_declaration', 3,
sub
#line 1038 "verilog.yapp"
{ f ("tf_output_declaration", @_[1..$#_]) }
	],
	[#Rule 313
		 'pip_tf_inout_declaration', 3,
sub
#line 1041 "verilog.yapp"
{ f ("tf_inout_declaration", @_[1..$#_]) }
	],
	[#Rule 314
		 'pip_tf_inout_declaration', 4,
sub
#line 1042 "verilog.yapp"
{ f ("tf_inout_declaration", @_[1..$#_]) }
	],
	[#Rule 315
		 'pic_tf_inout_declaration', 3,
sub
#line 1045 "verilog.yapp"
{ f ("tf_inout_declaration", @_[1..$#_]) }
	],
	[#Rule 316
		 'tf_inout_declaration', 3,
sub
#line 1048 "verilog.yapp"
{ f ("tf_inout_declaration", @_[1..$#_]) }
	],
	[#Rule 317
		 'task_port_type', 3,
sub
#line 1053 "verilog.yapp"
{ f ("task_port_type", @_[1..$#_]) }
	],
	[#Rule 318
		 'task_port_type', 1, undef
	],
	[#Rule 319
		 'task_port_type', 1, undef
	],
	[#Rule 320
		 'task_port_type', 1, undef
	],
	[#Rule 321
		 'task_port_type', 1, undef
	],
	[#Rule 322
		 'block_item_declarations', 1,
sub
#line 1062 "verilog.yapp"
{ f ("block_item_declarations", $_[1]) }
	],
	[#Rule 323
		 'block_item_declarations', 2,
sub
#line 1063 "verilog.yapp"
{ list (@_[1,2]) }
	],
	[#Rule 324
		 'block_item_declaration', 6,
sub
#line 1070 "verilog.yapp"
{
                              $_[3]->prepend_text ($_[2])->prepend_text ($_[1]);
                              $_[5]->append_text ($_[6]);
                              f ("block_reg_declaration", @_[3,4,5]);
                          }
	],
	[#Rule 325
		 'block_item_declaration', 4,
sub
#line 1076 "verilog.yapp"
{
                              $_[3]->prepend_text ($_[2])->prepend_text ($_[1]);
                              $_[3]->append_text ($_[4]);
                              f ("block_integer_declaration", $_[3]);
                          }
	],
	[#Rule 326
		 'block_item_declaration', 4,
sub
#line 1082 "verilog.yapp"
{
                              $_[3]->prepend_text ($_[2])->prepend_text ($_[1]);
                              $_[3]->append_text ($_[4]);
                              f ("block_time_declaration", $_[3]);
                          }
	],
	[#Rule 327
		 'block_item_declaration', 4,
sub
#line 1088 "verilog.yapp"
{
                              $_[3]->prepend_text ($_[2])->prepend_text ($_[1]);
                              $_[3]->append_text ($_[4]);
                              f ("block_real_declaration", $_[3]);
                          }
	],
	[#Rule 328
		 'block_item_declaration', 4,
sub
#line 1094 "verilog.yapp"
{
                              $_[3]->prepend_text ($_[2])->prepend_text ($_[1]);
                              $_[3]->append_text ($_[4]);
                              f ("block_realtime_declaration", $_[3]);
                          }
	],
	[#Rule 329
		 'block_item_declaration', 2,
sub
#line 1099 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); }
	],
	[#Rule 330
		 'block_item_declaration', 2,
sub
#line 1100 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 331
		 'block_item_declaration', 2,
sub
#line 1101 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 332
		 'list_of_block_variable_identifiers', 1,
sub
#line 1104 "verilog.yapp"
{ f ("list_of_block_variable_identifiers", $_[1]); }
	],
	[#Rule 333
		 'list_of_block_variable_identifiers', 3,
sub
#line 1105 "verilog.yapp"
{ $_[3]->prepend_text ($_[2]); $_[1]->append_children ($_[3]) }
	],
	[#Rule 334
		 'list_of_block_real_identifiers', 1,
sub
#line 1108 "verilog.yapp"
{ f ("list_of_block_real_identifiers", $_[1]) }
	],
	[#Rule 335
		 'list_of_block_real_identifiers', 3,
sub
#line 1109 "verilog.yapp"
{ list_delim (@_[1..$#_]); }
	],
	[#Rule 336
		 'block_variable_type', 2,
sub
#line 1112 "verilog.yapp"
{ f ("block_variable_type", @_[1,2]) }
	],
	[#Rule 337
		 'block_real_type', 2,
sub
#line 1115 "verilog.yapp"
{ f ("block_real_type", @_[1,2]) }
	],
	[#Rule 338
		 'module_instantiation', 4,
sub
#line 1129 "verilog.yapp"
{ $_[3]->append_text ($_[4]); f ("module_instantiation", $_[1], $_[2], $_[3]) }
	],
	[#Rule 339
		 'opt_parameter_value_assignment', 0,
sub
#line 1132 "verilog.yapp"
{ null }
	],
	[#Rule 340
		 'opt_parameter_value_assignment', 1, undef
	],
	[#Rule 341
		 'parameter_value_assignment', 4,
sub
#line 1136 "verilog.yapp"
{ $_[3]->prepend_text ($_[2])->prepend_text ($_[1])->append_text ($_[4]) }
	],
	[#Rule 342
		 'list_of_parameter_assignments', 1, undef
	],
	[#Rule 343
		 'list_of_parameter_assignments', 1, undef
	],
	[#Rule 344
		 'ordered_parameter_assignments', 1, undef
	],
	[#Rule 345
		 'named_parameter_assignments', 1,
sub
#line 1146 "verilog.yapp"
{ f ("named_parameter_assignments", $_[1]) }
	],
	[#Rule 346
		 'named_parameter_assignments', 3,
sub
#line 1147 "verilog.yapp"
{ $_[3]->prepend_text ($_[2]); $_[1]->append_children ($_[3]) }
	],
	[#Rule 347
		 'named_parameter_assignment', 5,
sub
#line 1150 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]);
                                                                                          $_[4]->prepend_text ($_[3])->append_text ($_[5]);
                                                                                          f ("named_parameter_assignment", @_[2,4]) }
	],
	[#Rule 348
		 'module_instances', 1,
sub
#line 1155 "verilog.yapp"
{ f ("module_instances", $_[1])  }
	],
	[#Rule 349
		 'module_instances', 3,
sub
#line 1156 "verilog.yapp"
{ list_delim (@_[1..$#_]) }
	],
	[#Rule 350
		 'module_instance', 4,
sub
#line 1159 "verilog.yapp"
{ $_[3]->prepend_text ($_[2]); $_[3]->append_text ($_[4]); f ("module_instance", @_[1,3]) }
	],
	[#Rule 351
		 'name_of_instance', 2,
sub
#line 1163 "verilog.yapp"
{ f ("name_of_instance", @_[1,2]) }
	],
	[#Rule 352
		 'opt_list_of_port_connections', 0,
sub
#line 1166 "verilog.yapp"
{ null }
	],
	[#Rule 353
		 'opt_list_of_port_connections', 1, undef
	],
	[#Rule 354
		 'list_of_port_connections', 1, undef
	],
	[#Rule 355
		 'list_of_port_connections', 1,
sub
#line 1175 "verilog.yapp"
{ f ("ordered_port_connections", $_[1]) }
	],
	[#Rule 356
		 'list_of_port_connections', 3,
sub
#line 1176 "verilog.yapp"
{
                                                                                     $_[3]->prepend_text ($_[2]);
                                                                                     $_[3]->prepend_children ($_[1])
                                                                                 }
	],
	[#Rule 357
		 'ordered_port_connections', 1,
sub
#line 1182 "verilog.yapp"
{ f ("ordered_port_connections", $_[1]) }
	],
	[#Rule 358
		 'ordered_port_connections', 3,
sub
#line 1183 "verilog.yapp"
{ list_delim (@_[1..$#_]) }
	],
	[#Rule 359
		 'ordered_port_connection', 1, undef
	],
	[#Rule 360
		 'named_port_connections', 1,
sub
#line 1189 "verilog.yapp"
{ f ("named_port_connections", $_[1]) }
	],
	[#Rule 361
		 'named_port_connections', 3,
sub
#line 1190 "verilog.yapp"
{ $_[3]->prepend_text ($_[2]); $_[1]->append_children ($_[3]) }
	],
	[#Rule 362
		 'named_port_connection', 5,
sub
#line 1193 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); $_[4]->prepend_text ($_[3])->append_text ($_[5]); f ("named_port_connection", @_[2,4]) }
	],
	[#Rule 363
		 'generated_instantiation', 3,
sub
#line 1198 "verilog.yapp"
{ $_[2]->prepend_text ($_[1])->append_text ($_[3]);
                                                                         f ("generated_instantiation", $_[2]) }
	],
	[#Rule 364
		 'generate_item_or_null', 1, undef
	],
	[#Rule 365
		 'generate_item_or_null', 1,
sub
#line 1203 "verilog.yapp"
{ null->append_text ($_[1]) }
	],
	[#Rule 366
		 'opt_generate_items', 0,
sub
#line 1206 "verilog.yapp"
{ null }
	],
	[#Rule 367
		 'opt_generate_items', 1, undef
	],
	[#Rule 368
		 'generate_items', 1,
sub
#line 1210 "verilog.yapp"
{ f ("generate_items", $_[1]) }
	],
	[#Rule 369
		 'generate_items', 2,
sub
#line 1211 "verilog.yapp"
{ $_[1]->append_children ($_[2]) }
	],
	[#Rule 370
		 'generate_item', 1, undef
	],
	[#Rule 371
		 'generate_item', 1, undef
	],
	[#Rule 372
		 'generate_item', 1, undef
	],
	[#Rule 373
		 'generate_item', 1, undef
	],
	[#Rule 374
		 'generate_item', 1, undef
	],
	[#Rule 375
		 'generate_conditional_statement', 6,
sub
#line 1227 "verilog.yapp"
{
                                    $_[3]->prepend_text ($_[2])->prepend_text ($_[1]);
                                    $_[3]->append_text ($_[4]);
                                    f ("generate_conditional_statement", @_[3,5,6]);
                                }
	],
	[#Rule 376
		 'opt_generate_conditional_statement_else', 0,
sub
#line 1234 "verilog.yapp"
{ null }
	],
	[#Rule 377
		 'opt_generate_conditional_statement_else', 2,
sub
#line 1235 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 378
		 'generate_case_statement', 6,
sub
#line 1244 "verilog.yapp"
{
                             $_[3]->prepend_text ($_[2])->prepend_text ($_[1]);
                             $_[3]->append_text ($_[4]);
                             $_[5]->append_text ($_[6]);
                             f ("generate_case_statement", @_[3,5]);
                         }
	],
	[#Rule 379
		 'genvar_case_items', 1,
sub
#line 1252 "verilog.yapp"
{ f ("genvar_case_items", $_[1]) }
	],
	[#Rule 380
		 'genvar_case_items', 2,
sub
#line 1253 "verilog.yapp"
{ list (@_[1,2]) }
	],
	[#Rule 381
		 'constant_expressions', 1,
sub
#line 1256 "verilog.yapp"
{ f ("constant_expressions", $_[1]) }
	],
	[#Rule 382
		 'constant_expressions', 3,
sub
#line 1257 "verilog.yapp"
{ list (@_[1,2]) }
	],
	[#Rule 383
		 'genvar_case_item', 3,
sub
#line 1260 "verilog.yapp"
{ $_[1]->append_text ($_[2]); f ("genvar_case_item", @_[1,3]); }
	],
	[#Rule 384
		 'genvar_case_item', 3,
sub
#line 1261 "verilog.yapp"
{ $_[1]->append_text ($_[2]); f ("genvar_case_item", @_[1,3]); }
	],
	[#Rule 385
		 'genvar_case_item', 2,
sub
#line 1262 "verilog.yapp"
{                             f ("genvar_case_item", @_[1,2]); }
	],
	[#Rule 386
		 'generate_loop_statement', 13,
sub
#line 1278 "verilog.yapp"
{
                               $_[3]->prepend_text ($_[2])->prepend_text ($_[1]);
                               $_[3]->append_text ($_[4]);
                               $_[5]->append_text ($_[6]);
                               $_[7]->append_text ($_[8]);
                               $_[7]->append_text ($_[9]);
                               $_[7]->append_text ($_[10]);
                               $_[12]->append_text ($_[13]);
                               f ("generate_loop_statement", @_[3,5,7,11,12]);
                           }
	],
	[#Rule 387
		 'genvar_assignment', 3,
sub
#line 1290 "verilog.yapp"
{ $_[1]->append_text ($_[2]); f ("genvar_assignment", @_[1,3]) }
	],
	[#Rule 388
		 'generate_block', 4,
sub
#line 1294 "verilog.yapp"
{
                      $_[2]->prepend_text ($_[1]); $_[3]->append_text ($_[4]);
                      f ("generate_block", @_[2,3]);
                  }
	],
	[#Rule 389
		 'opt_generate_block_identifier', 0,
sub
#line 1300 "verilog.yapp"
{ null }
	],
	[#Rule 390
		 'opt_generate_block_identifier', 2,
sub
#line 1301 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 391
		 'udp_declaration', 2, undef
	],
	[#Rule 392
		 'continuous_assign', 5,
sub
#line 1316 "verilog.yapp"
{ VP3::ParseTree->factory ("continuous_assign", @_[1..$#_]); }
	],
	[#Rule 393
		 'list_of_net_assignments', 1,
sub
#line 1319 "verilog.yapp"
{ VP3::ParseTree->factory ("list_of_net_assignments", $_[1]) }
	],
	[#Rule 394
		 'list_of_net_assignments', 3,
sub
#line 1320 "verilog.yapp"
{ $_[3]->prepend_text ($_[2]); $_[1]->append_children ($_[3]) }
	],
	[#Rule 395
		 'net_assignment', 1, undef
	],
	[#Rule 396
		 'assignment', 3,
sub
#line 1328 "verilog.yapp"
{ $_[1]->append_text ($_[2]); f ("assignment", "continuous", $_[1], null, $_[3]); }
	],
	[#Rule 397
		 'initial_construct', 2,
sub
#line 1334 "verilog.yapp"
{ f ("initial_construct", $_[2]->prepend_text ($_[1])) }
	],
	[#Rule 398
		 'always_construct', 2,
sub
#line 1337 "verilog.yapp"
{ f ("always_construct", $_[2]->prepend_text ($_[1])) }
	],
	[#Rule 399
		 'blocking_assignment', 4,
sub
#line 1341 "verilog.yapp"
{ $_[1]->append_text ($_[2]); f ("assignment", "blocking", @_[1,3,4]) }
	],
	[#Rule 400
		 'nonblocking_assignment', 4,
sub
#line 1345 "verilog.yapp"
{ $_[1]->append_text ($_[2]); f ("assignment", "nonblocking", @_[1,3,4]) }
	],
	[#Rule 401
		 'procedural_continuous_assignment', 2,
sub
#line 1352 "verilog.yapp"
{ f ("procedural_continuous_assignment", @_[2,3]) }
	],
	[#Rule 402
		 'procedural_continuous_assignment', 2,
sub
#line 1353 "verilog.yapp"
{ f ("procedural_continuous_assignment", @_[2,3]) }
	],
	[#Rule 403
		 'procedural_continuous_assignment', 2,
sub
#line 1354 "verilog.yapp"
{ f ("procedural_continuous_assignment", @_[2,3]) }
	],
	[#Rule 404
		 'procedural_continuous_assignment', 2,
sub
#line 1355 "verilog.yapp"
{ f ("procedural_continuous_assignment", @_[2,3]) }
	],
	[#Rule 405
		 'variable_assignment', 1, undef
	],
	[#Rule 406
		 'block_identifier_and_declarations', 3,
sub
#line 1365 "verilog.yapp"
{
                                                                                          $_[2]->prepend_text ($_[1]);
                                                                                          f ("block_identifier_and_declarations", $_[2], $_[3])
                                                                                      }
	],
	[#Rule 407
		 'par_block', 3,
sub
#line 1371 "verilog.yapp"
{ f ("par_block",  null, $_[2])->prepend_text ($_[1])->append_text ($_[3]) }
	],
	[#Rule 408
		 'par_block', 4,
sub
#line 1372 "verilog.yapp"
{ f ("par_block", $_[2], $_[3])->prepend_text ($_[1])->append_text ($_[4]) }
	],
	[#Rule 409
		 'seq_block', 3,
sub
#line 1375 "verilog.yapp"
{ f ("seq_block",  null, $_[2])->prepend_text ($_[1])->append_text ($_[3]) }
	],
	[#Rule 410
		 'seq_block', 4,
sub
#line 1376 "verilog.yapp"
{ f ("seq_block", $_[2], $_[3])->prepend_text ($_[1])->append_text ($_[4]) }
	],
	[#Rule 411
		 'opt_statements', 0,
sub
#line 1381 "verilog.yapp"
{ null }
	],
	[#Rule 412
		 'opt_statements', 1, undef
	],
	[#Rule 413
		 'statements', 1,
sub
#line 1385 "verilog.yapp"
{ f ("statements", $_[1]) }
	],
	[#Rule 414
		 'statements', 2,
sub
#line 1386 "verilog.yapp"
{ $_[1]->append_children ($_[2]) }
	],
	[#Rule 415
		 'statement', 3,
sub
#line 1389 "verilog.yapp"
{ $_[2]->prepend_text ($_[1])->append_text ($_[3]) }
	],
	[#Rule 416
		 'statement', 2,
sub
#line 1390 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 417
		 'statement', 2,
sub
#line 1391 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 418
		 'statement', 2,
sub
#line 1392 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 419
		 'statement', 2,
sub
#line 1393 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 420
		 'statement', 2,
sub
#line 1394 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 421
		 'statement', 3,
sub
#line 1395 "verilog.yapp"
{ $_[2]->prepend_text ($_[1])->append_text ($_[3]) }
	],
	[#Rule 422
		 'statement', 2,
sub
#line 1396 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 423
		 'statement', 3,
sub
#line 1397 "verilog.yapp"
{ $_[2]->prepend_text ($_[1])->append_text ($_[3]) }
	],
	[#Rule 424
		 'statement', 2,
sub
#line 1398 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 425
		 'statement', 2,
sub
#line 1399 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 426
		 'statement', 2,
sub
#line 1400 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 427
		 'statement', 2,
sub
#line 1401 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 428
		 'statement', 2,
sub
#line 1402 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 429
		 'statement_or_null', 1, undef
	],
	[#Rule 430
		 'statement_or_null', 2,
sub
#line 1406 "verilog.yapp"
{ null->prepend_text ($_[1])->append_text ($_[2]) }
	],
	[#Rule 431
		 'function_statement', 1, undef
	],
	[#Rule 432
		 'delay_control', 2,
sub
#line 1415 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); f ("delay_control", $_[2]) }
	],
	[#Rule 433
		 'delay_control', 4,
sub
#line 1416 "verilog.yapp"
{
                                                      $_[3]->prepend_text ($_[2])->prepend_text ($_[1]);
                                                      $_[3]->append_text ($_[4]);
                                                      f("delay_control", $_[3]);
                                                  }
	],
	[#Rule 434
		 'opt_delay_or_event_control', 0,
sub
#line 1423 "verilog.yapp"
{ null }
	],
	[#Rule 435
		 'opt_delay_or_event_control', 1, undef
	],
	[#Rule 436
		 'delay_or_event_control', 1, undef
	],
	[#Rule 437
		 'delay_or_event_control', 1, undef
	],
	[#Rule 438
		 'delay_or_event_control', 5,
sub
#line 1429 "verilog.yapp"
{
                                                                        $_[3]->prepend_text ($_[2]);
                                                                        $_[3]->append_text ($_[4]);
                                                                        f ("repeat_event_control", @_[3,5]);
                                                                    }
	],
	[#Rule 439
		 'disable_statement', 3,
sub
#line 1436 "verilog.yapp"
{ $_[2]->prepend_text ($_[1])->append_text ($_[3]);
                                                                         f ("disable_statement", $_[2]) }
	],
	[#Rule 440
		 'event_control', 2,
sub
#line 1441 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); f ("event_control", $_[2]) }
	],
	[#Rule 441
		 'event_control', 4,
sub
#line 1442 "verilog.yapp"
{
                                                    $_[3]->prepend_text ($_[2])->prepend_text ($_[1]);
                                                    $_[3]->append_text ($_[4]);
                                                    f ("event_control", $_[3]);
                                                }
	],
	[#Rule 442
		 'event_control', 2,
sub
#line 1447 "verilog.yapp"
{ f ("wildcard_event_control")->prepend_text ($_[1])->append_text ($_[2]) }
	],
	[#Rule 443
		 'event_control', 4,
sub
#line 1448 "verilog.yapp"
{ f ("wildcard_event_control")->prepend_text ($_[1])->append_text ($_[2])->append_text ($_[3])->append_text ($_[4]) }
	],
	[#Rule 444
		 'event_control', 3,
sub
#line 1449 "verilog.yapp"
{ f ("wildcard_event_control")->prepend_text ($_[1])->append_text ($_[2])->append_text ($_[3]) }
	],
	[#Rule 445
		 'event_control', 2,
sub
#line 1450 "verilog.yapp"
{ f ("wildcard_event_control")->prepend_text ($_[1])->append_text ($_[2]) }
	],
	[#Rule 446
		 'event_control', 3,
sub
#line 1451 "verilog.yapp"
{ f ("wildcard_event_control")->prepend_text ($_[1])->append_text ($_[2])->append_text ($_[3]) }
	],
	[#Rule 447
		 'event_trigger', 4,
sub
#line 1454 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]);
                                                                               $_[3]->append_text ($_[4]);
                                                                               f ("event_trigger", $_[2], $_[3]) }
	],
	[#Rule 448
		 'event_expressions', 1,
sub
#line 1459 "verilog.yapp"
{ f ("event_expressions", $_[1]) }
	],
	[#Rule 449
		 'event_expressions', 3,
sub
#line 1460 "verilog.yapp"
{ list_delim (@_[1..$#_]) }
	],
	[#Rule 450
		 'event_expressions', 3,
sub
#line 1461 "verilog.yapp"
{ list_delim (@_[1..$#_]) }
	],
	[#Rule 451
		 'event_expression', 1,
sub
#line 1464 "verilog.yapp"
{ f ("event_expression",  null, $_[1]) }
	],
	[#Rule 452
		 'event_expression', 2,
sub
#line 1465 "verilog.yapp"
{ f ("event_expression", $_[1], $_[2]) }
	],
	[#Rule 453
		 'event_expression', 2,
sub
#line 1466 "verilog.yapp"
{ f ("event_expression", $_[1], $_[2]) }
	],
	[#Rule 454
		 'procedural_timing_control', 1, undef
	],
	[#Rule 455
		 'procedural_timing_control', 1, undef
	],
	[#Rule 456
		 'procedural_timing_control_statement', 2,
sub
#line 1473 "verilog.yapp"
{ f ("procedural_timing_control_statement", @_[1..$#_]) }
	],
	[#Rule 457
		 'wait_statement', 5,
sub
#line 1477 "verilog.yapp"
{
                    $_[3]->prepend_text ($_[2])->prepend_text ($_[1]);
                    $_[3]->append_text ($_[4]);
                    f ("wait_statement", @_[3,5]);
                }
	],
	[#Rule 458
		 'conditional_statement', 6,
sub
#line 1489 "verilog.yapp"
{ $_[3]->prepend_text ($_[2])->prepend_text ($_[1]); $_[3]->append_text ($_[4]); f ("conditional_statement", @_[3,5,6]) }
	],
	[#Rule 459
		 'opt_else', 0,
sub
#line 1492 "verilog.yapp"
{ null }
	],
	[#Rule 460
		 'opt_else', 2,
sub
#line 1493 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]) }
	],
	[#Rule 461
		 'case_token', 1, undef
	],
	[#Rule 462
		 'case_token', 1, undef
	],
	[#Rule 463
		 'case_token', 1, undef
	],
	[#Rule 464
		 'case_statement', 6,
sub
#line 1501 "verilog.yapp"
{ $_[3]->prepend_text ($_[2])->prepend_text ($_[1]); $_[3]->append_text ($_[4]); $_[5]->append_text ($_[6]); f ("case_statement", @_[3,5]) }
	],
	[#Rule 465
		 'case_items', 1,
sub
#line 1504 "verilog.yapp"
{ f ("case_items", $_[1]) }
	],
	[#Rule 466
		 'case_items', 2,
sub
#line 1505 "verilog.yapp"
{ $_[1]->append_children ($_[2]) }
	],
	[#Rule 467
		 'case_item', 3,
sub
#line 1508 "verilog.yapp"
{ $_[1]->append_text ($_[2]); f ("case_item", @_[1,3]) }
	],
	[#Rule 468
		 'case_item', 3,
sub
#line 1509 "verilog.yapp"
{ $_[1]->append_text ($_[2]); f ("case_item", @_[1,3]) }
	],
	[#Rule 469
		 'case_item', 2,
sub
#line 1510 "verilog.yapp"
{                             f ("case_item", @_[1,2]) }
	],
	[#Rule 470
		 'loop_statement', 2,
sub
#line 1516 "verilog.yapp"
{
                      $_[2]->prepend_text ($_[1]);
                      f ("forever_statement", $_[2]);
                  }
	],
	[#Rule 471
		 'loop_statement', 5,
sub
#line 1525 "verilog.yapp"
{
                      $_[3]->prepend_text ($_[2])->prepend_text ($_[1]);
                      $_[3]->append_text ($_[4]);
                      f ("repeat_statement", @_[3,5]);
                  }
	],
	[#Rule 472
		 'loop_statement', 5,
sub
#line 1535 "verilog.yapp"
{
                      $_[3]->prepend_text ($_[2])->prepend_text ($_[1]);
                      $_[3]->append_text ($_[4]);
                      f ("while_statement", @_[3,5]);
                  }
	],
	[#Rule 473
		 'loop_statement', 9,
sub
#line 1549 "verilog.yapp"
{
                      $_[3]->prepend_text ($_[2])->prepend_text ($_[1]);
                      $_[3]->append_text ($_[4]);
                      $_[5]->append_text ($_[6]);
                      $_[7]->append_text ($_[8]);
                      f ("for_statement", @_[3,5,7,9]);
                  }
	],
	[#Rule 474
		 'system_task_enable', 3,
sub
#line 1560 "verilog.yapp"
{ $_[2]->append_text ($_[3]); f ("task_enable", @_[1,2]) }
	],
	[#Rule 475
		 'task_enable', 3,
sub
#line 1563 "verilog.yapp"
{ $_[2]->append_text ($_[3]); f ("task_enable", @_[1,2]) }
	],
	[#Rule 476
		 'specify_block', 3,
sub
#line 1572 "verilog.yapp"
{
                    $_[2]->prepend_text ($_[1]);
                    $_[2]->append_text ($_[3]);
                    f ("specify_block", $_[2]);
                }
	],
	[#Rule 477
		 'specify_input_terminal_descriptor', 1,
sub
#line 1588 "verilog.yapp"
{ f ("specify_input_terminal_descriptor", $_[1], null ) }
	],
	[#Rule 478
		 'specify_input_terminal_descriptor', 4,
sub
#line 1589 "verilog.yapp"
{ $_[3]->prepend_text ($_[2])->append_text ($_[4]);
                                                                           f ("specify_input_terminal_descriptor", $_[1], $_[3]) }
	],
	[#Rule 479
		 'specify_output_terminal_descriptor', 1,
sub
#line 1593 "verilog.yapp"
{ f ("specify_output_terminal_descriptor", $_[1], null ) }
	],
	[#Rule 480
		 'specify_output_terminal_descriptor', 4,
sub
#line 1594 "verilog.yapp"
{ $_[3]->prepend_text ($_[2])->append_text ($_[4]);
                                                                            f ("specify_output_terminal_descriptor", $_[1], $_[3]) }
	],
	[#Rule 481
		 'concatenation', 3,
sub
#line 1609 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); $_[2]->append_text ($_[3]); f ("concatenation", $_[2]) }
	],
	[#Rule 482
		 'multiple_concatenation', 4,
sub
#line 1612 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]);
                                                           $_[3]->append_text ($_[4]);
                                                           f ("multiple_concatenation", @_[2,3])
                                                         }
	],
	[#Rule 483
		 'function_call', 5,
sub
#line 1623 "verilog.yapp"
{
                     $_[4]->prepend_text ($_[3]);
                     $_[4]->prepend_text ($_[2]);
                     $_[4]->append_text ($_[5]);
                     f ("function_call", @_[1,4]);
                 }
	],
	[#Rule 484
		 'system_function_call', 2,
sub
#line 1631 "verilog.yapp"
{ f ("function_call", @_[1,2]); }
	],
	[#Rule 485
		 'base_expression', 1, undef
	],
	[#Rule 486
		 'conditional_expression', 6,
sub
#line 1639 "verilog.yapp"
{
                            $_[1]->append_text ($_[2]);
                            $_[4]->prepend_text ($_[3]);
                            $_[4]->append_text ($_[5]);
                            f ("conditional_expression", @_[1,4,6]);
                        }
	],
	[#Rule 487
		 'constant_expression', 1, undef
	],
	[#Rule 488
		 'constant_mintypmax_expression', 1, undef
	],
	[#Rule 489
		 'dimension_constant_expression', 1, undef
	],
	[#Rule 490
		 'expressions', 1,
sub
#line 1656 "verilog.yapp"
{ f ("expressions", $_[1]) }
	],
	[#Rule 491
		 'expressions', 3,
sub
#line 1657 "verilog.yapp"
{ $_[3]->prepend_text ($_[2]); $_[1]->append_children ($_[3]) }
	],
	[#Rule 492
		 'expression', 1, undef
	],
	[#Rule 493
		 'expression', 1, undef
	],
	[#Rule 494
		 'expression', 1, undef
	],
	[#Rule 495
		 'expression', 1, undef
	],
	[#Rule 496
		 'expression', 1, undef
	],
	[#Rule 497
		 'unary_operator_expression', 3,
sub
#line 1667 "verilog.yapp"
{ f ("unary_operator_expression", @_[1..$#_]) }
	],
	[#Rule 498
		 'binary_operator_expression', 4,
sub
#line 1670 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 499
		 'binary_operator_expression', 4,
sub
#line 1671 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 500
		 'binary_operator_expression', 4,
sub
#line 1672 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 501
		 'binary_operator_expression', 4,
sub
#line 1673 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 502
		 'binary_operator_expression', 4,
sub
#line 1674 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 503
		 'binary_operator_expression', 4,
sub
#line 1675 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 504
		 'binary_operator_expression', 4,
sub
#line 1676 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 505
		 'binary_operator_expression', 4,
sub
#line 1677 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 506
		 'binary_operator_expression', 4,
sub
#line 1678 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 507
		 'binary_operator_expression', 4,
sub
#line 1679 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 508
		 'binary_operator_expression', 4,
sub
#line 1680 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 509
		 'binary_operator_expression', 4,
sub
#line 1681 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 510
		 'binary_operator_expression', 4,
sub
#line 1682 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 511
		 'binary_operator_expression', 4,
sub
#line 1683 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 512
		 'binary_operator_expression', 4,
sub
#line 1684 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 513
		 'binary_operator_expression', 4,
sub
#line 1685 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 514
		 'binary_operator_expression', 4,
sub
#line 1686 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 515
		 'binary_operator_expression', 4,
sub
#line 1687 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 516
		 'binary_operator_expression', 4,
sub
#line 1688 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 517
		 'binary_operator_expression', 4,
sub
#line 1689 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 518
		 'binary_operator_expression', 4,
sub
#line 1690 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 519
		 'binary_operator_expression', 4,
sub
#line 1691 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 520
		 'binary_operator_expression', 4,
sub
#line 1692 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 521
		 'binary_operator_expression', 4,
sub
#line 1693 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 522
		 'binary_operator_expression', 4,
sub
#line 1694 "verilog.yapp"
{ binop (@_) }
	],
	[#Rule 523
		 'lsb_constant_expression', 1, undef
	],
	[#Rule 524
		 'opt_mintypmax_expression', 0,
sub
#line 1699 "verilog.yapp"
{ null }
	],
	[#Rule 525
		 'opt_mintypmax_expression', 1, undef
	],
	[#Rule 526
		 'mintypmax_expression', 1, undef
	],
	[#Rule 527
		 'mintypmax_expression', 5,
sub
#line 1704 "verilog.yapp"
{ $_[1]->append_text ($_[2]);
                                                                   $_[3]->append_text ($_[4]);
                                                                   f ("mintypmax_expression", @_[1,3,5]) }
	],
	[#Rule 528
		 'msb_constant_expression', 1, undef
	],
	[#Rule 529
		 'range_expression', 1, undef
	],
	[#Rule 530
		 'range_expression', 1, undef
	],
	[#Rule 531
		 'range_expression_colon', 3,
sub
#line 1717 "verilog.yapp"
{ f ("range_expression_colon", @_[1..$#_]) }
	],
	[#Rule 532
		 'range_expression_colon', 3,
sub
#line 1718 "verilog.yapp"
{ f ("range_expression_colon", @_[1..$#_]) }
	],
	[#Rule 533
		 'range_expression_colon', 3,
sub
#line 1719 "verilog.yapp"
{ f ("range_expression_colon", @_[1..$#_]) }
	],
	[#Rule 534
		 'width_constant_expression', 1, undef
	],
	[#Rule 535
		 'primary', 1, undef
	],
	[#Rule 536
		 'primary', 1, undef
	],
	[#Rule 537
		 'primary', 2,
sub
#line 1733 "verilog.yapp"
{ f ("identifier_subscripts", @_[1..$#_]) }
	],
	[#Rule 538
		 'primary', 1, undef
	],
	[#Rule 539
		 'primary', 1, undef
	],
	[#Rule 540
		 'primary', 1, undef
	],
	[#Rule 541
		 'primary', 1, undef
	],
	[#Rule 542
		 'primary', 3,
sub
#line 1738 "verilog.yapp"
{ $_[2]->prepend_text ($_[1])->append_text ($_[3]) }
	],
	[#Rule 543
		 'lvalues', 1,
sub
#line 1743 "verilog.yapp"
{ f ("lvalue_concatenation", $_[1]) }
	],
	[#Rule 544
		 'lvalues', 3,
sub
#line 1744 "verilog.yapp"
{ $_[3]->prepend_text ($_[2]); $_[1]->append_children ($_[3]) }
	],
	[#Rule 545
		 'lvalue', 1, undef
	],
	[#Rule 546
		 'lvalue', 2,
sub
#line 1748 "verilog.yapp"
{ f ("identifier_subscripts", @_[1..$#_]) }
	],
	[#Rule 547
		 'lvalue', 3,
sub
#line 1749 "verilog.yapp"
{ $_[2]->prepend_text ($_[1])->append_text ($_[3]); }
	],
	[#Rule 548
		 'unary_operator', 1, undef
	],
	[#Rule 549
		 'unary_operator', 1, undef
	],
	[#Rule 550
		 'unary_operator', 1, undef
	],
	[#Rule 551
		 'unary_operator', 1, undef
	],
	[#Rule 552
		 'unary_operator', 1, undef
	],
	[#Rule 553
		 'unary_operator', 1, undef
	],
	[#Rule 554
		 'unary_operator', 1, undef
	],
	[#Rule 555
		 'unary_operator', 1, undef
	],
	[#Rule 556
		 'unary_operator', 1, undef
	],
	[#Rule 557
		 'unary_operator', 1, undef
	],
	[#Rule 558
		 'unary_operator', 1, undef
	],
	[#Rule 559
		 'number', 1, undef
	],
	[#Rule 560
		 'number', 1, undef
	],
	[#Rule 561
		 'number', 2,
sub
#line 1779 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]);
                                          $_[2]->width (VP3::Expression::eval_unsigned_number (undef, $_[1]));
                                          $_[2] }
	],
	[#Rule 562
		 'number', 1, undef
	],
	[#Rule 563
		 'real_number', 3,
sub
#line 1785 "verilog.yapp"
{ $_[1]->append_text ($_[2]);                              f ("real_number", $_[1], $_[3],  null,  null) }
	],
	[#Rule 564
		 'real_number', 4,
sub
#line 1786 "verilog.yapp"
{                             $_[3]->prepend_text ($_[2]); f ("real_number", $_[1],  null, $_[3], $_[4]) }
	],
	[#Rule 565
		 'real_number', 6,
sub
#line 1787 "verilog.yapp"
{ $_[1]->append_text ($_[2]); $_[5]->prepend_text ($_[4]); f ("real_number", $_[1], $_[3], $_[5], $_[6]) }
	],
	[#Rule 566
		 'exp', 1, undef
	],
	[#Rule 567
		 'exp', 1, undef
	],
	[#Rule 568
		 'opt_sign', 0,
sub
#line 1792 "verilog.yapp"
{ null }
	],
	[#Rule 569
		 'opt_sign', 1, undef
	],
	[#Rule 570
		 'opt_sign', 1, undef
	],
	[#Rule 571
		 'string', 1, undef
	],
	[#Rule 572
		 'attr', 0,
sub
#line 1809 "verilog.yapp"
{ null }
	],
	[#Rule 573
		 'attr', 3,
sub
#line 1810 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); $_[2]->append_text ($_[3]); }
	],
	[#Rule 574
		 'attr_specs', 1,
sub
#line 1813 "verilog.yapp"
{ f ("attr_specs", $_[1]) }
	],
	[#Rule 575
		 'attr_specs', 3,
sub
#line 1814 "verilog.yapp"
{ $_[3]->prepend_text ($_[2]); $_[1]->append_children ($_[3]) }
	],
	[#Rule 576
		 'attr_spec', 3,
sub
#line 1817 "verilog.yapp"
{ $_[1]->append_text ($_[2]); f ("attr_spec", $_[1], $_[3]) }
	],
	[#Rule 577
		 'attr_spec', 1,
sub
#line 1818 "verilog.yapp"
{                             f ("attr_spec", $_[1], null)  }
	],
	[#Rule 578
		 'attr_name', 1, undef
	],
	[#Rule 579
		 'block_identifier', 1, undef
	],
	[#Rule 580
		 'event_identifier', 1, undef
	],
	[#Rule 581
		 'function_identifier', 1, undef
	],
	[#Rule 582
		 'generate_block_identifier', 1, undef
	],
	[#Rule 583
		 'genvar_identifier', 1, undef
	],
	[#Rule 584
		 'hierarchical_event_identifier', 1, undef
	],
	[#Rule 585
		 'hierarchical_function_identifier', 1, undef
	],
	[#Rule 586
		 'hierarchical_identifier_piece', 2,
sub
#line 1844 "verilog.yapp"
{ $_[1]->append_text ($_[2]) }
	],
	[#Rule 587
		 'hierarchical_identifier_pieces', 1,
sub
#line 1847 "verilog.yapp"
{ f ("hierarchical_identifier_pieces", $_[1]) }
	],
	[#Rule 588
		 'hierarchical_identifier_pieces', 2,
sub
#line 1848 "verilog.yapp"
{ $_[1]->append_children ($_[2]) }
	],
	[#Rule 589
		 'hierarchical_identifier', 2,
sub
#line 1851 "verilog.yapp"
{ f ("hierarchical_identifier", @_[1..$#_]) }
	],
	[#Rule 590
		 'hierarchical_identifier', 1, undef
	],
	[#Rule 591
		 'hierarchical_parameter_identifier', 1, undef
	],
	[#Rule 592
		 'hierarchical_task_identifier', 1, undef
	],
	[#Rule 593
		 'hierarchical_task_or_block_identifier', 1, undef
	],
	[#Rule 594
		 'module_identifier', 1, undef
	],
	[#Rule 595
		 'module_instance_identifier', 1, undef
	],
	[#Rule 596
		 'net_identifier', 1, undef
	],
	[#Rule 597
		 'parameter_identifier', 1, undef
	],
	[#Rule 598
		 'port_identifier', 1, undef
	],
	[#Rule 599
		 'real_identifier', 1, undef
	],
	[#Rule 600
		 'specparam_identifier', 1, undef
	],
	[#Rule 601
		 'system_function_identifier', 1, undef
	],
	[#Rule 602
		 'system_task_identifier', 1, undef
	],
	[#Rule 603
		 'task_identifier', 1, undef
	],
	[#Rule 604
		 'variable_identifier', 1, undef
	],
	[#Rule 605
		 'vp3_parse_start', 3,
sub
#line 1892 "verilog.yapp"
{ $_[2]->append_text ($_[3]) }
	],
	[#Rule 606
		 'vp3_parse_start', 3,
sub
#line 1893 "verilog.yapp"
{ $_[2]->append_text ($_[3]) }
	],
	[#Rule 607
		 'vp3_parse_start', 3,
sub
#line 1894 "verilog.yapp"
{ $_[2]->append_text ($_[3]) }
	],
	[#Rule 608
		 'vp3_parse_start', 3,
sub
#line 1895 "verilog.yapp"
{ $_[2]->append_text ($_[3]) }
	],
	[#Rule 609
		 'vp3_parse_start', 3,
sub
#line 1896 "verilog.yapp"
{ $_[2]->append_text ($_[3]) }
	],
	[#Rule 610
		 'opt_vp3_directive_text_items', 1, undef
	],
	[#Rule 611
		 'opt_vp3_directive_text_items', 0,
sub
#line 1902 "verilog.yapp"
{ f ("vp3_directive_text_items") }
	],
	[#Rule 612
		 'vp3_directive_text_items', 1,
sub
#line 1905 "verilog.yapp"
{ f ("vp3_directive_text_items", $_[1]) }
	],
	[#Rule 613
		 'vp3_directive_text_items', 2,
sub
#line 1906 "verilog.yapp"
{ list (@_[1,2]) }
	],
	[#Rule 614
		 'vp3_module_item', 1, undef
	],
	[#Rule 615
		 'vp3_module_item', 1, undef
	],
	[#Rule 616
		 'vp3_module_item', 1, undef
	],
	[#Rule 617
		 'vp3_module_item', 1, undef
	],
	[#Rule 618
		 'vp3_module_item', 1, undef
	],
	[#Rule 619
		 'vp3_module_item', 1, undef
	],
	[#Rule 620
		 'vp3_module_item', 1, undef
	],
	[#Rule 621
		 'vp3_ports_directive', 2,
sub
#line 1918 "verilog.yapp"
{ f ("vp3_ports_directive", @_[1..$#_]) }
	],
	[#Rule 622
		 'vp3_wires_directive', 2,
sub
#line 1921 "verilog.yapp"
{ f ("vp3_wires_directive", @_[1..$#_]) }
	],
	[#Rule 623
		 'vp3_regs_directive', 2,
sub
#line 1924 "verilog.yapp"
{ f ("vp3_regs_directive", @_[1..$#_]) }
	],
	[#Rule 624
		 'vp3_module_directive', 3,
sub
#line 1930 "verilog.yapp"
{
                          my $d = f ("vp3_module_directive", $_[0]->YYData->{basename}, @_[1..$#_]);
                          if ($d->opt_none) {
                              $_[0]->YYData->{lexer}{state} = VP3::Lexer::ST_INSERT;
                              push @{$_[0]->YYData->{lexer}{insert_toks}}, 'VP3_PARSE_MODE_MODULE_NONE';
                          }
                          $d;
                      }
	],
	[#Rule 625
		 'vp3_instance_directive', 3,
sub
#line 1943 "verilog.yapp"
{
                            f ("vp3_instance_directive", @_[1..$#_]);
                        }
	],
	[#Rule 626
		 'vp3_vector_directive', 4,
sub
#line 1948 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); $_[3]->append_text ($_[4]); f ("vp3_vector_directive", @_[2,3]) }
	],
	[#Rule 627
		 'vp3_vector_directive', 4,
sub
#line 1949 "verilog.yapp"
{ $_[2]->prepend_text ($_[1]); $_[3]->append_text ($_[4]); f ("vp3_vector_directive", @_[2,3]) }
	],
	[#Rule 628
		 'vp3_force_directive', 3,
sub
#line 1952 "verilog.yapp"
{ $_[2]->prepend ($_[1]); $_[2]->append ($_[3]);
                                                 f ("vp3_force_directive", "input", $_[2]) }
	],
	[#Rule 629
		 'vp3_force_directive', 3,
sub
#line 1954 "verilog.yapp"
{ $_[2]->prepend ($_[1]); $_[2]->append ($_[3]);
                                                  f ("vp3_force_directive", "output", $_[2]) }
	],
	[#Rule 630
		 'vp3_waive_directive', 4,
sub
#line 1958 "verilog.yapp"
{ $_[2]->prepend ($_[1]); $_[3]->append ($_[4]); f ("vp3_waive_directive", @_[2,3]) }
	]
],
                                  @_);
    bless($self,$class);
}

#line 1961 "verilog.yapp"


# vim: sts=4 sw=4 et

1;
