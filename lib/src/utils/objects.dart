// /// This class consists of {@code static} utility methods for operating
// /// on objects, or checking certain conditions before operation.  These utilities
// /// include {@code null}-safe or {@code null}-tolerant methods for computing the
// /// hash code of an object, returning a string for an object, comparing two
// /// objects, and checking if indexes or sub-range values are out of bounds.
// ///
// class Objects {
//      Objects._() {
//         throw  AssertionError("No java.util.Objects instances for you!");
//     }

//     /// Returns {@code true} if the arguments are equal to each other
//     /// and {@code false} otherwise.
//     /// Consequently, if both arguments are {@code null}, {@code true}
//     /// is returned.  Otherwise, if the first argument is not {@code
//     /// null}, equality is determined by calling the {@link
//     /// Object#equals equals} method of the first argument with the
//     /// second argument of this method. Otherwise, {@code false} is
//     /// returned.
//     ///
//     /// @param a an object
//     /// @param b an object to be compared with {@code a} for equality
//     /// @return {@code true} if the arguments are equal to each other
//     /// and {@code false} otherwise
//     /// @see Object#equals(Object)
//      static bool equals(Object? a, Object? b) {
//         return a == b;
//     }

//    /// Returns {@code true} if the arguments are deeply equal to each other
//    /// and {@code false} otherwise.
//    ///
//    /// Two {@code null} values are deeply equal.  If both arguments are
//    /// arrays, the algorithm in {@link Arrays#deepEquals(Object[],
//    /// Object[]) Arrays.deepEquals} is used to determine equality.
//    /// Otherwise, equality is determined by using the {@link
//    /// Object#equals equals} method of the first argument.
//    ///
//    /// @param a an object
//    /// @param b an object to be compared with {@code a} for deep equality
//    /// @return {@code true} if the arguments are deeply equal to each other
//    /// and {@code false} otherwise
//    /// @see Arrays#deepEquals(Object[], Object[])
//    /// @see Objects#equals(Object, Object)
//      static bool deepEquals(Object a, Object b) {
//         if (a == b)
//             return true;
//         else if (a == null || b == null)
//             return false;
//         else
//             return Arrays.deepEquals0(a, b);
//     }

//     /// Returns the hash code of a non-{@code null} argument and 0 for
//     /// a {@code null} argument.
//     ///
//     /// @param o an object
//     /// @return the hash code of a non-{@code null} argument and 0 for
//     /// a {@code null} argument
//     /// @see Object#hashCode
//      static int hashCode(Object? o) {
//         return o?.hashCode ?? 0;
//     }

//    /// Generates a hash code for a sequence of input values. The hash
//    /// code is generated as if all the input values were placed into an
//    /// array, and that array were hashed by calling {@link
//    /// Arrays#hashCode(Object[])}.
//    ///
//    /// <p>This method is useful for implementing {@link
//    /// Object#hashCode()} on objects containing multiple fields. For
//    /// example, if an object that has three fields, {@code x}, {@code
//    /// y}, and {@code z}, one could write:
//    ///
//    /// <blockquote><pre>
//    /// &#064;Override  int hashCode() {
//    ///     return Objects.hash(x, y, z);
//    /// }
//    /// </pre></blockquote>
//    ///
//    /// <b>Warning: When a single object reference is supplied, the returned
//    /// value does not equal the hash code of that object reference.</b> This
//    /// value can be computed by calling {@link #hashCode(Object)}.
//    ///
//    /// @param values the values to be hashed
//    /// @return a hash value of the sequence of input values
//    /// @see Arrays#hashCode(Object[])
//    /// @see List#hashCode
//      static int hash(Object... values) {
//         return Arrays.hashCode(values);
//     }

//     /// Returns the result of calling {@code toString} for a non-{@code
//     /// null} argument and {@code "null"} for a {@code null} argument.
//     ///
//     /// @param o an object
//     /// @return the result of calling {@code toString} for a non-{@code
//     /// null} argument and {@code "null"} for a {@code null} argument
//     /// @see Object#toString
//     /// @see String#valueOf(Object)
//      static String toString(Object o,{String? nullDefault}) {
//         return String.valueOf(o);
//     }

//     /// Returns the result of calling {@code toString} on the first
//     /// argument if the first argument is not {@code null} and returns
//     /// the second argument otherwise.
//     ///
//     /// @param o an object
//     /// @param nullDefault string to return if the first argument is
//     ///        {@code null}
//     /// @return the result of calling {@code toString} on the first
//     /// argument if it is not {@code null} and the second argument
//     /// otherwise.
//     /// @see Objects#toString(Object)
//      static String toString(Object o, String nullDefault) {
//         return (o != null) ? o.toString() : nullDefault;
//     }

//     /// Returns 0 if the arguments are identical and {@code
//     /// c.compare(a, b)} otherwise.
//     /// Consequently, if both arguments are {@code null} 0
//     /// is returned.
//     ///
//     /// <p>Note that if one of the arguments is {@code null}, a {@code
//     /// NullPointerException} may or may not be thrown depending on
//     /// what ordering policy, if any, the {@link Comparator Comparator}
//     /// chooses to have for {@code null} values.
//     ///
//     /// @param <T> the type of the objects being compared
//     /// @param a an object
//     /// @param b an object to be compared with {@code a}
//     /// @param c the {@code Comparator} to compare the first two arguments
//     /// @return 0 if the arguments are identical and {@code
//     /// c.compare(a, b)} otherwise.
//     /// @see Comparable
//     /// @see Comparator
//      static <T> int compare(T a, T b, Comparator<? super T> c) {
//         return (a == b) ? 0 :  c.compare(a, b);
//     }

//     /// Checks that the specified object reference is not {@code null}. This
//     /// method is designed primarily for doing parameter validation in methods
//     /// and constructors, as demonstrated below:
//     /// <blockquote><pre>
//     ///  Foo(Bar bar) {
//     ///     this.bar = Objects.requireNonNull(bar);
//     /// }
//     /// </pre></blockquote>
//     ///
//     /// @param obj the object reference to check for nullity
//     /// @param <T> the type of the reference
//     /// @return {@code obj} if not {@code null}
//     /// @throws NullPointerException if {@code obj} is {@code null}
//      static <T> T requireNonNull(T obj) {
//         if (obj == null)
//             throw new NullPointerException();
//         return obj;
//     }

//     /// Checks that the specified object reference is not {@code null} and
//     /// throws a customized {@link NullPointerException} if it is. This method
//     /// is designed primarily for doing parameter validation in methods and
//     /// constructors with multiple parameters, as demonstrated below:
//     /// <blockquote><pre>
//     ///  Foo(Bar bar, Baz baz) {
//     ///     this.bar = Objects.requireNonNull(bar, "bar must not be null");
//     ///     this.baz = Objects.requireNonNull(baz, "baz must not be null");
//     /// }
//     /// </pre></blockquote>
//     ///
//     /// @param obj     the object reference to check for nullity
//     /// @param message detail message to be used in the event that a {@code
//     ///                NullPointerException} is thrown
//     /// @param <T> the type of the reference
//     /// @return {@code obj} if not {@code null}
//     /// @throws NullPointerException if {@code obj} is {@code null}
//      static T requireNonNull<T>(T? obj, String message) {
//         if (obj == null)
//             throw new NullPointerException(message);
//         return obj;
//     }

//     /// Returns {@code true} if the provided reference is {@code null} otherwise
//     /// returns {@code false}.
//     ///
//     /// @apiNote This method exists to be used as a
//     /// {@link java.util.function.Predicate}, {@code filter(Objects::isNull)}
//     ///
//     /// @param obj a reference to be checked against {@code null}
//     /// @return {@code true} if the provided reference is {@code null} otherwise
//     /// {@code false}
//     ///
//     /// @see java.util.function.Predicate
//     /// @since 1.8
//      static bool isNull(Object? obj) {
//         return obj == null;
//     }

//     /// Returns {@code true} if the provided reference is non-{@code null}
//     /// otherwise returns {@code false}.
//     ///
//     /// @apiNote This method exists to be used as a
//     /// {@link java.util.function.Predicate}, {@code filter(Objects::nonNull)}
//     ///
//     /// @param obj a reference to be checked against {@code null}
//     /// @return {@code true} if the provided reference is non-{@code null}
//     /// otherwise {@code false}
//     ///
//     /// @see java.util.function.Predicate
//     /// @since 1.8
//      static bool nonNull(Object obj) {
//         return obj != null;
//     }

//     /// Returns the first argument if it is non-{@code null} and
//     /// otherwise returns the non-{@code null} second argument.
//     ///
//     /// @param obj an object
//     /// @param defaultObj a non-{@code null} object to return if the first argument
//     ///                   is {@code null}
//     /// @param <T> the type of the reference
//     /// @return the first argument if it is non-{@code null} and
//     ///        otherwise the second argument if it is non-{@code null}
//     /// @throws NullPointerException if both {@code obj} is null and
//     ///        {@code defaultObj} is {@code null}
//     /// @since 9
//      static <T> T requireNonNullElse(T obj, T defaultObj) {
//         return (obj != null) ? obj : requireNonNull(defaultObj, "defaultObj");
//     }

//     /// Returns the first argument if it is non-{@code null} and otherwise
//     /// returns the non-{@code null} value of {@code supplier.get()}.
//     ///
//     /// @param obj an object
//     /// @param supplier of a non-{@code null} object to return if the first argument
//     ///                 is {@code null}
//     /// @param <T> the type of the first argument and return type
//     /// @return the first argument if it is non-{@code null} and otherwise
//     ///         the value from {@code supplier.get()} if it is non-{@code null}
//     /// @throws NullPointerException if both {@code obj} is null and
//     ///        either the {@code supplier} is {@code null} or
//     ///        the {@code supplier.get()} value is {@code null}
//     /// @since 9
//      static <T> T requireNonNullElseGet(T obj, Supplier<? extends T> supplier) {
//         return (obj != null) ? obj
//                 : requireNonNull(requireNonNull(supplier, "supplier").get(), "supplier.get()");
//     }

//     /// Checks that the specified object reference is not {@code null} and
//     /// throws a customized {@link NullPointerException} if it is.
//     ///
//     /// <p>Unlike the method {@link #requireNonNull(Object, String)},
//     /// this method allows creation of the message to be deferred until
//     /// after the null check is made. While this may confer a
//     /// performance advantage in the non-null case, when deciding to
//     /// call this method care should be taken that the costs of
//     /// creating the message supplier are less than the cost of just
//     /// creating the string message directly.
//     ///
//     /// @param obj     the object reference to check for nullity
//     /// @param messageSupplier supplier of the detail message to be
//     /// used in the event that a {@code NullPointerException} is thrown
//     /// @param <T> the type of the reference
//     /// @return {@code obj} if not {@code null}
//     /// @throws NullPointerException if {@code obj} is {@code null}
//     /// @since 1.8
//      static <T> T requireNonNull(T obj, Supplier<String> messageSupplier) {
//         if (obj == null)
//             throw new NullPointerException(messageSupplier == null ?
//                                            null : messageSupplier.get());
//         return obj;
//     }

//     /// Checks if the {@code index} is within the bounds of the range from
//     /// {@code 0} (inclusive) to {@code length} (exclusive).
//     ///
//     /// <p>The {@code index} is defined to be out of bounds if any of the
//     /// following inequalities is true:
//     /// <ul>
//     ///  <li>{@code index < 0}</li>
//     ///  <li>{@code index >= length}</li>
//     ///  <li>{@code length < 0}, which is implied from the former inequalities</li>
//     /// </ul>
//     ///
//     /// @param index the index
//     /// @param length the upper-bound (exclusive) of the range
//     /// @return {@code index} if it is within bounds of the range
//     /// @throws IndexOutOfBoundsException if the {@code index} is out of bounds
//     /// @since 9
//     @ForceInline
//      static
//     int checkIndex(int index, int length) {
//         return Preconditions.checkIndex(index, length, null);
//     }

//     /// Checks if the sub-range from {@code fromIndex} (inclusive) to
//     /// {@code toIndex} (exclusive) is within the bounds of range from {@code 0}
//     /// (inclusive) to {@code length} (exclusive).
//     ///
//     /// <p>The sub-range is defined to be out of bounds if any of the following
//     /// inequalities is true:
//     /// <ul>
//     ///  <li>{@code fromIndex < 0}</li>
//     ///  <li>{@code fromIndex > toIndex}</li>
//     ///  <li>{@code toIndex > length}</li>
//     ///  <li>{@code length < 0}, which is implied from the former inequalities</li>
//     /// </ul>
//     ///
//     /// @param fromIndex the lower-bound (inclusive) of the sub-range
//     /// @param toIndex the upper-bound (exclusive) of the sub-range
//     /// @param length the upper-bound (exclusive) the range
//     /// @return {@code fromIndex} if the sub-range within bounds of the range
//     /// @throws IndexOutOfBoundsException if the sub-range is out of bounds
//     /// @since 9
//      static
//     int checkFromToIndex(int fromIndex, int toIndex, int length) {
//         return Preconditions.checkFromToIndex(fromIndex, toIndex, length, null);
//     }

//     /// Checks if the sub-range from {@code fromIndex} (inclusive) to
//     /// {@code fromIndex + size} (exclusive) is within the bounds of range from
//     /// {@code 0} (inclusive) to {@code length} (exclusive).
//     ///
//     /// <p>The sub-range is defined to be out of bounds if any of the following
//     /// inequalities is true:
//     /// <ul>
//     ///  <li>{@code fromIndex < 0}</li>
//     ///  <li>{@code size < 0}</li>
//     ///  <li>{@code fromIndex + size > length}, taking into account integer overflow</li>
//     ///  <li>{@code length < 0}, which is implied from the former inequalities</li>
//     /// </ul>
//     ///
//     /// @param fromIndex the lower-bound (inclusive) of the sub-interval
//     /// @param size the size of the sub-range
//     /// @param length the upper-bound (exclusive) of the range
//     /// @return {@code fromIndex} if the sub-range within bounds of the range
//     /// @throws IndexOutOfBoundsException if the sub-range is out of bounds
//     /// @since 9
//      static
//     int checkFromIndexSize(int fromIndex, int size, int length) {
//         return Preconditions.checkFromIndexSize(fromIndex, size, length, null);
//     }

//     /// Checks if the {@code index} is within the bounds of the range from
//     /// {@code 0} (inclusive) to {@code length} (exclusive).
//     ///
//     /// <p>The {@code index} is defined to be out of bounds if any of the
//     /// following inequalities is true:
//     /// <ul>
//     ///  <li>{@code index < 0}</li>
//     ///  <li>{@code index >= length}</li>
//     ///  <li>{@code length < 0}, which is implied from the former inequalities</li>
//     /// </ul>
//     ///
//     /// @param index the index
//     /// @param length the upper-bound (exclusive) of the range
//     /// @return {@code index} if it is within bounds of the range
//     /// @throws IndexOutOfBoundsException if the {@code index} is out of bounds
//     /// @since 16
//     @ForceInline
//      static
//     long checkIndex(long index, long length) {
//         return Preconditions.checkIndex(index, length, null);
//     }

//     /// Checks if the sub-range from {@code fromIndex} (inclusive) to
//     /// {@code toIndex} (exclusive) is within the bounds of range from {@code 0}
//     /// (inclusive) to {@code length} (exclusive).
//     ///
//     /// <p>The sub-range is defined to be out of bounds if any of the following
//     /// inequalities is true:
//     /// <ul>
//     ///  <li>{@code fromIndex < 0}</li>
//     ///  <li>{@code fromIndex > toIndex}</li>
//     ///  <li>{@code toIndex > length}</li>
//     ///  <li>{@code length < 0}, which is implied from the former inequalities</li>
//     /// </ul>
//     ///
//     /// @param fromIndex the lower-bound (inclusive) of the sub-range
//     /// @param toIndex the upper-bound (exclusive) of the sub-range
//     /// @param length the upper-bound (exclusive) the range
//     /// @return {@code fromIndex} if the sub-range within bounds of the range
//     /// @throws IndexOutOfBoundsException if the sub-range is out of bounds
//     /// @since 16
//      static
//     long checkFromToIndex(long fromIndex, long toIndex, long length) {
//         return Preconditions.checkFromToIndex(fromIndex, toIndex, length, null);
//     }

//     /// Checks if the sub-range from {@code fromIndex} (inclusive) to
//     /// {@code fromIndex + size} (exclusive) is within the bounds of range from
//     /// {@code 0} (inclusive) to {@code length} (exclusive).
//     ///
//     /// <p>The sub-range is defined to be out of bounds if any of the following
//     /// inequalities is true:
//     /// <ul>
//     ///  <li>{@code fromIndex < 0}</li>
//     ///  <li>{@code size < 0}</li>
//     ///  <li>{@code fromIndex + size > length}, taking into account integer overflow</li>
//     ///  <li>{@code length < 0}, which is implied from the former inequalities</li>
//     /// </ul>
//     ///
//     /// @param fromIndex the lower-bound (inclusive) of the sub-interval
//     /// @param size the size of the sub-range
//     /// @param length the upper-bound (exclusive) of the range
//     /// @return {@code fromIndex} if the sub-range within bounds of the range
//     /// @throws IndexOutOfBoundsException if the sub-range is out of bounds
//     /// @since 16
//      static
//     long checkFromIndexSize(long fromIndex, long size, long length) {
//         return Preconditions.checkFromIndexSize(fromIndex, size, length, null);
//     }
// }